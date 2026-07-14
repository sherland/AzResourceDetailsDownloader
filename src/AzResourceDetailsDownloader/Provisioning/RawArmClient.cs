using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Azure.Core;

namespace AzResourceDetailsDownloader.Provisioning;

public sealed class RawArmClient(TokenCredential credential) : IDisposable
{
    private static readonly string[] Scopes = ["https://management.azure.com/.default"];
    private static readonly TimeSpan DefaultProvisioningTimeout = TimeSpan.FromMinutes(10);
    private static readonly TimeSpan PollInterval = TimeSpan.FromSeconds(4);

    private readonly HttpClient _httpClient = new();

    public async Task<JsonDocument> GetRawAsync(string resourceId, string apiVersion, CancellationToken ct = default) =>
        await SendAsync(HttpMethod.Get, resourceId, apiVersion, body: null, ct)
            ?? throw new InvalidOperationException($"ARM GET '{resourceId}' (api {apiVersion}) returned an empty body.");

    public async Task PutAsync(
        string resourceId, string apiVersion, string jsonBody, TimeSpan? provisioningTimeout = null, CancellationToken ct = default)
    {
        // Some resource types respond to the initial PUT with an empty body (e.g. 202 Accepted for a
        // long-running create) rather than the resource JSON — that's fine, we only need the GET-based
        // provisioning-state poll below to know when it's actually done.
        using var _ = await SendAsync(HttpMethod.Put, resourceId, apiVersion, jsonBody, ct);
        await WaitForProvisioningSucceededAsync(resourceId, apiVersion, provisioningTimeout ?? DefaultProvisioningTimeout, ct);
    }

    private async Task WaitForProvisioningSucceededAsync(
        string resourceId, string apiVersion, TimeSpan provisioningTimeout, CancellationToken ct)
    {
        var deadline = DateTime.UtcNow + provisioningTimeout;
        while (true)
        {
            JsonDocument? doc;
            try
            {
                doc = await GetRawAsync(resourceId, apiVersion, ct);
            }
            catch (InvalidOperationException) when (DateTime.UtcNow < deadline)
            {
                // Immediately after an async PUT, the resource can briefly 404 before it's fully registered.
                await Task.Delay(PollInterval, ct);
                continue;
            }
            catch (HttpRequestException) when (DateTime.UtcNow < deadline)
            {
                // A long poll (Redis Cache alone can run 15-20+ minutes) can hit a transient dropped/reset
                // connection along the way — treat it the same as a momentary blip, not a hard failure.
                await Task.Delay(PollInterval, ct);
                continue;
            }

            using var _ = doc;
            var state = TryGetProvisioningState(doc);

            if (state is null || string.Equals(state, "Succeeded", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            if (string.Equals(state, "Failed", StringComparison.OrdinalIgnoreCase)
                || string.Equals(state, "Canceled", StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException($"Resource '{resourceId}' provisioning ended in state '{state}'.");
            }

            if (DateTime.UtcNow >= deadline)
            {
                throw new TimeoutException($"Timed out waiting for '{resourceId}' to finish provisioning (last state: '{state}').");
            }

            await Task.Delay(PollInterval, ct);
        }
    }

    private static string? TryGetProvisioningState(JsonDocument doc) =>
        doc.RootElement.TryGetProperty("properties", out var props)
        && props.TryGetProperty("provisioningState", out var stateElement)
            ? stateElement.GetString()
            : null;

    private async Task<JsonDocument?> SendAsync(HttpMethod method, string resourceId, string apiVersion, string? body, CancellationToken ct)
    {
        var token = await credential.GetTokenAsync(new TokenRequestContext(Scopes), ct);

        using var request = new HttpRequestMessage(method, $"https://management.azure.com{resourceId}?api-version={apiVersion}");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token.Token);
        if (body is not null)
        {
            request.Content = new StringContent(body, Encoding.UTF8, "application/json");
        }

        using var response = await _httpClient.SendAsync(request, ct);
        var responseBody = await response.Content.ReadAsStringAsync(ct);

        if (!response.IsSuccessStatusCode)
        {
            throw new InvalidOperationException(
                $"ARM {method} '{resourceId}' (api {apiVersion}) failed with {(int)response.StatusCode}: {responseBody}");
        }

        return string.IsNullOrWhiteSpace(responseBody) ? null : JsonDocument.Parse(responseBody);
    }

    public void Dispose() => _httpClient.Dispose();
}

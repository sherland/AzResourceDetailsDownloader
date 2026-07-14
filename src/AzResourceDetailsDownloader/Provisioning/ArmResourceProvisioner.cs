using System.Text;
using System.Text.Json;

namespace AzResourceDetailsDownloader.Provisioning;

public sealed class ArmResourceProvisioner(RawArmClient armClient)
{
    public async Task<ProvisionedResourceRef> CreateOrUpdateAsync(
        string subscriptionId,
        string resourceGroupName,
        string armType,
        string apiVersion,
        string name,
        string location,
        JsonElement requestBody,
        TimeSpan? provisioningTimeout = null,
        CancellationToken ct = default)
    {
        var resourceId = ResourceIdBuilder.Build(subscriptionId, resourceGroupName, armType, name);
        var body = BuildRequestBody(location, requestBody);

        await armClient.PutAsync(resourceId.ToString(), apiVersion, body, provisioningTimeout, ct);

        return new ProvisionedResourceRef(resourceId.ToString(), name);
    }

    private static string BuildRequestBody(string location, JsonElement requestBody)
    {
        using var stream = new MemoryStream();
        using (var writer = new Utf8JsonWriter(stream))
        {
            writer.WriteStartObject();
            writer.WriteString("location", location);
            foreach (var property in requestBody.EnumerateObject())
            {
                property.WriteTo(writer);
            }
            writer.WriteEndObject();
        }

        return Encoding.UTF8.GetString(stream.ToArray());
    }
}

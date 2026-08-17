using System.Text.Json;
using System.Text.RegularExpressions;

namespace AzResourceDetailsDownloader.Provisioning;

// Key is populated only for prerequisites that both support it (currently just Storage Accounts —
// see RawArmClient.ListStorageAccountPrimaryKeyAsync) and are actually referenced via
// {prereq.<alias>.key} downstream (see ResourceTypePipeline) — most prerequisites never resolve it.
public sealed record ProvisionedResourceRef(string Id, string Name, string Location, string? Key = null);

public static class TemplateTokenResolver
{
    private static readonly Regex PrereqTokenRegex = new(
        @"\{prereq\.(?<alias>[A-Za-z0-9_]+)\.(?<field>id|name|location|key)\}", RegexOptions.Compiled);

    private static readonly Regex RandTokenRegex = new(
        @"\{rand(?<len>\d+)\}", RegexOptions.Compiled);

    private static readonly Regex SecretTokenRegex = new(
        @"\{secret\.(?<key>[A-Za-z0-9_]+)\}", RegexOptions.Compiled);

    public static IEnumerable<string> FindPrereqAliasReferences(string text) =>
        PrereqTokenRegex.Matches(text)
            .Select(m => m.Groups["alias"].Value)
            .Distinct(StringComparer.OrdinalIgnoreCase);

    // Used by ResourceTypePipeline to decide whether a just-provisioned prerequisite needs its
    // access key fetched via an extra listKeys call — checked across every downstream text (later
    // prerequisites' bodies, the target's own body) rather than eagerly fetching for every
    // prerequisite, since listKeys is only implemented for Storage Accounts and would fail loudly
    // (correctly) if attempted against a type that doesn't support it.
    public static bool ReferencesPrereqKey(string text, string alias) =>
        PrereqTokenRegex.Matches(text).Any(m =>
            m.Groups["field"].Value == "key" && string.Equals(m.Groups["alias"].Value, alias, StringComparison.OrdinalIgnoreCase));

    public static string ResolvePrereqTokens(string text, IReadOnlyDictionary<string, ProvisionedResourceRef> resolved) =>
        PrereqTokenRegex.Replace(text, m =>
        {
            var alias = m.Groups["alias"].Value;
            if (!resolved.TryGetValue(alias, out var reference))
            {
                throw new InvalidOperationException($"Unresolved prerequisite alias '{alias}'.");
            }

            return m.Groups["field"].Value switch
            {
                "id" => reference.Id,
                "name" => reference.Name,
                "key" => reference.Key ?? throw new InvalidOperationException(
                    $"Prerequisite '{alias}' has no resolved key — {{prereq.*.key}} is currently only " +
                    "supported for Microsoft.Storage/storageAccounts prerequisites."),
                _ => reference.Location
            };
        });

    public static string ResolveRandomTokens(string text, string charset, Random random) =>
        RandTokenRegex.Replace(text, m => NameGenerator.RandomString(int.Parse(m.Groups["len"].Value), charset, random));

    public static string ResolveSecretTokens(string text, IReadOnlyDictionary<string, string> secrets) =>
        SecretTokenRegex.Replace(text, m =>
        {
            var key = m.Groups["key"].Value;
            if (!secrets.TryGetValue(key, out var value))
            {
                throw new InvalidOperationException(
                    $"Unresolved secret '{key}'. Set it via configuration key 'Secrets:{key}' " +
                    $"(e.g. environment variable ARDL_Secrets__{key}).");
            }

            return value;
        });

    public static JsonElement ResolveAllTokens(
        JsonElement requestBody,
        IReadOnlyDictionary<string, ProvisionedResourceRef> prereqs,
        IReadOnlyDictionary<string, string> secrets,
        string charset,
        Random random)
    {
        var text = requestBody.GetRawText();
        text = ResolvePrereqTokens(text, prereqs);
        text = ResolveSecretTokens(text, secrets);
        text = ResolveRandomTokens(text, charset, random);

        using var document = JsonDocument.Parse(text);
        return document.RootElement.Clone();
    }
}

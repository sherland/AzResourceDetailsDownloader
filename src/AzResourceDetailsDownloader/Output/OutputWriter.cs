using System.Text.Json;
using AzResourceDetailsDownloader.Capture;

namespace AzResourceDetailsDownloader.Output;

public static class OutputWriter
{
    private static readonly JsonSerializerOptions PrettyPrint = new() { WriteIndented = true };

    public static async Task WriteAsync(
        string outputRoot, string armType, string category, JsonDocument rawJson, byte[]? screenshot,
        string subscriptionId, string tenantId, string actualRgName,
        string? bicep = null, string? terraform = null, IReadOnlyList<string>? bannerNotices = null,
        IReadOnlyList<PortalField>? portalFields = null, string? userPrincipalName = null,
        CancellationToken ct = default)
    {
        var dir = Path.Combine(outputRoot, CategoryKey.From(category), ArmTypeKey.From(armType));
        Directory.CreateDirectory(dir);

        // Subscription ID, tenant ID, the (randomly-generated, real) resource group name, and the
        // signed-in user's UPN (ARM auto-stamps this into every resource's systemData.createdBy/
        // lastModifiedBy) all vary per run and per whoever runs the tool — normalized to fixed
        // placeholders here so the committed text files diff-stably regardless and don't leak the
        // operator's identity. The screenshot can't be normalized this way (it's a rendered image).
        var prettyJson = JsonSerializer.Serialize(rawJson.RootElement, PrettyPrint);
        prettyJson = OutputNormalizer.Normalize(prettyJson, subscriptionId, tenantId, actualRgName, armType, userPrincipalName);
        await File.WriteAllTextAsync(Path.Combine(dir, "data.json"), prettyJson, ct);

        if (screenshot is not null)
        {
            await File.WriteAllBytesAsync(Path.Combine(dir, "portal.png"), screenshot, ct);
        }

        if (bicep is not null)
        {
            bicep = OutputNormalizer.Normalize(bicep, subscriptionId, tenantId, actualRgName, armType, userPrincipalName);
            await File.WriteAllTextAsync(Path.Combine(dir, "resource-group.bicep"), bicep, ct);
        }

        if (terraform is not null)
        {
            terraform = OutputNormalizer.Normalize(terraform, subscriptionId, tenantId, actualRgName, armType, userPrincipalName);
            await File.WriteAllTextAsync(Path.Combine(dir, "resource-group.tf"), terraform, ct);
        }

        var notesPath = Path.Combine(dir, "notes.md");
        if (bannerNotices is { Count: > 0 })
        {
            var body = "# Portal notices\n\n"
                + "Text automatically extracted from info/warning boxes on the Overview blade at capture time "
                + $"(deprecation notices, security recommendations, breaking-change warnings, etc.) for `{armType}`.\n\n"
                + string.Join("\n\n", bannerNotices.Select(n => $"- {n}"));
            await File.WriteAllTextAsync(notesPath, body, ct);
        }
        else if (File.Exists(notesPath))
        {
            // A previous run captured a banner that's no longer present (e.g. Azure removed a notice) —
            // don't leave a stale notes.md behind implying it's still current.
            File.Delete(notesPath);
        }

        // The Overview blade's "Essentials" panel — Azure's own answer to "which fields matter for
        // this resource type" — captured as structured label/value pairs, not just pixels in
        // portal.png. Intended to drive template authoring (e.g. AzToMd's per-type Scriban templates)
        // without hand-reading the raw ARM JSON blind. See EssentialsExtractor for how this is scraped.
        var fieldsPath = Path.Combine(dir, "portal-fields.json");
        if (portalFields is { Count: > 0 })
        {
            // Subscription/tenant/RG *ID* values get the same GUID/RG-name substitution as
            // data.json/bicep/tf; human-readable display names (Directory Name, Subscription) need
            // separate label-targeted redaction since they're not the ID string being replaced.
            var redactedFields = OutputNormalizer.NormalizePortalFields(portalFields);
            var fieldsJson = JsonSerializer.Serialize(redactedFields, PrettyPrint);
            fieldsJson = OutputNormalizer.Normalize(fieldsJson, subscriptionId, tenantId, actualRgName, armType, userPrincipalName);
            await File.WriteAllTextAsync(fieldsPath, fieldsJson, ct);
        }
        else if (File.Exists(fieldsPath))
        {
            File.Delete(fieldsPath);
        }
    }
}

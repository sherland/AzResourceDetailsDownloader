using System.Text.Json;
using AzResourceDetailsDownloader.Options;
using AzResourceDetailsDownloader.Templating;

namespace AzResourceDetailsDownloader.Tests;

public class TemplateGeneratorTests
{
    [Fact]
    public void Generate_OmitsContextField_WithExplanatoryComment()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var fields = new (string, string)[] { ("Subscription", "Example Subscription") };

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);

        Assert.DoesNotContain("| **Subscription**", template);
        Assert.Contains("omitted: tenant/subscription identity", template);
    }

    [Fact]
    public void Generate_UnresolvedField_KeepsRowAsTodoWithCapturedExampleInsideTheComment()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var fields = new (string, string)[] { ("Operating system", "Linux") };

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);

        Assert.Contains("| **Operating system** |", template);
        Assert.Contains("TODO (Unresolved)", template);
        Assert.Contains("Linux", template); // present as the hint's captured-example, inside the comment
    }

    // The actual bug this format exists to prevent, live-caught in a real generated template
    // ("| **Virtual network** | <!-- TODO ... --> vnetw4qxan-j |" rendered "vnetw4qxan-j" as a
    // plain visible table cell — indistinguishable from real data for whichever resource the
    // template was later rendered against). Everything after the comment's closing "-->" is what
    // actually renders as Markdown; the captured example must never appear there.
    [Fact]
    public void Generate_UnresolvedField_NeverRendersTheCapturedExampleAsVisibleCellContent()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var fields = new (string, string)[] { ("Operating system", "a-genuinely-unique-example-marker") };

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);

        var row = template.Split('\n').Single(l => l.Contains("Operating system"));
        var visibleCellContent = row[(row.IndexOf("-->", StringComparison.Ordinal) + 3)..];
        Assert.DoesNotContain("a-genuinely-unique-example-marker", visibleCellContent);
        Assert.Contains("*Not available from captured ARM metadata.*", visibleCellContent);
    }

    // A captured value containing a literal "-->" must not be able to close the HTML comment
    // early — that would leak the rest of the comment's own text (the hint, the "Captured
    // example:" label) as visible rendered content, the exact same class of bug as above.
    [Fact]
    public void Generate_UnresolvedField_CapturedExampleContainingCommentCloser_CannotBreakOutOfTheComment()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var fields = new (string, string)[] { ("Operating system", "malicious--> escape attempt") };

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);

        var row = template.Split('\n').Single(l => l.Contains("Operating system"));
        // Exactly one real comment-closer: the generator's own, not one smuggled in from the value.
        Assert.Equal(1, row.Split("-->", StringSplitOptions.None).Length - 1);
        var visibleCellContent = row[(row.IndexOf("-->", StringComparison.Ordinal) + 3)..];
        Assert.Contains("*Not available from captured ARM metadata.*", visibleCellContent);
        Assert.DoesNotContain("escape attempt", visibleCellContent);
    }

    // The actual point of this session's discussion: a genuinely live/transient field that
    // couldn't be resolved (VM power state isn't in the capture body at all) must not render a
    // stale example value dressed up as a TODO — it needs an honest "check the portal" placeholder.
    [Fact]
    public void Generate_UnresolvedLiveStateField_RendersSeePortalPlaceholder_NotStaleExample()
    {
        var root = LoadCapturedResource("compute_and_web", "microsoft_compute_virtualmachines");
        var fields = new (string, string)[] { ("Status", "Running") };

        var template = TemplateGenerator.Generate("Microsoft.Compute/virtualMachines", fields, root);

        Assert.Contains("See the Azure Portal for current status", template);
        Assert.DoesNotContain("TODO (", template);
        Assert.DoesNotContain("Running", template);
    }

    // A resolvable live-state field (Container Registry's "Provisioning state" is a real
    // properties.provisioningState passthrough) must still show the real value — just flagged as a
    // snapshot, not silently indistinguishable from a durable setting.
    [Fact]
    public void Generate_ResolvedLiveStateField_ShowsValueWithStalenessCaveat()
    {
        var root = LoadCapturedResource("containers", "microsoft_containerregistry_registries");
        var fields = new (string, string)[] { ("Provisioning state", "Succeeded") };

        var template = TemplateGenerator.Generate("Microsoft.ContainerRegistry/registries", fields, root);

        Assert.Contains("model.props.provisioningstate", template);
        Assert.Contains("as of last sync", template);
        Assert.DoesNotContain("TODO (", template);
    }

    [Fact]
    public void Generate_BooleanField_UsesEnabledDisabledTransform_WhenCapturedValueIsEnabled()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var fields = new (string, string)[] { ("Soft-delete", "Enabled") };

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);

        Assert.Contains("model.props.enablesoftdelete | portal_bool_enabled", template);
    }

    [Fact]
    public void Generate_BooleanField_UsesYesNoTransform_WhenCapturedValueIsYes()
    {
        var root = LoadCapturedResource("analytics_and_iot", "microsoft_databricks_workspaces");
        var fields = new (string, string)[] { ("Enable No Public IP", "Yes") };

        var template = TemplateGenerator.Generate("Microsoft.Databricks/workspaces", fields, root);

        Assert.Contains("| portal_bool_yesno", template);
    }

    [Fact]
    public void Generate_Location_AppliesRegionDisplayNameTransform()
    {
        var root = LoadCapturedResource("security", "microsoft_keyvault_vaults");
        var fields = new (string, string)[] { ("Location", "Norway East") };

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);

        Assert.Contains("model.location | region_display_name", template);
    }

    [Fact]
    public void Generate_DirectStringMatch_WithCasingDifference_AppliesCapitalizeTransform()
    {
        var root = LoadCapturedResource("containers", "microsoft_containerregistry_registries");
        var fields = new (string, string)[] { ("Soft delete (Preview)", "Disabled") };

        var template = TemplateGenerator.Generate("Microsoft.ContainerRegistry/registries", fields, root);

        Assert.Contains("model.props.policies.softdeletepolicy.status | string.capitalize", template);
    }

    // End-to-end: parsing + rendering the generated template against the SAME capture it was built
    // from must reproduce every real portal-fields.json value exactly — the strongest possible
    // check that the whole pipeline (resolve -> generate -> render) agrees with itself.
    [Fact]
    public void GenerateAndRender_KeyVault_ReproducesEveryCapturedValueExactly()
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();
        var dir = Path.Combine(repoRoot, "output", "security", "microsoft_keyvault_vaults");
        var root = LoadResourceFromDir(dir);
        var fields = LoadPortalFields(dir);

        var template = TemplateGenerator.Generate("Microsoft.KeyVault/vaults", fields, root);
        var rendered = TemplateRenderer.Render(template, root, "Microsoft.KeyVault/vaults");

        // Tenant/subscription identity fields are deliberately omitted from the body (already in
        // frontmatter, see Generate_OmitsContextField_WithExplanatoryComment) — everything else
        // must reproduce exactly.
        foreach (var (label, value) in fields.Where(f => !PortalFieldKnowledge.TenantIdentityAllowedValues.ContainsKey(f.Label)))
        {
            Assert.Contains(value, rendered);
        }
    }

    [Fact]
    public void GenerateAndRender_ContainerRegistry_ReproducesResolvableValuesExactly()
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();
        var dir = Path.Combine(repoRoot, "output", "containers", "microsoft_containerregistry_registries");
        var root = LoadResourceFromDir(dir);
        var fields = LoadPortalFields(dir);

        var template = TemplateGenerator.Generate("Microsoft.ContainerRegistry/registries", fields, root);
        var rendered = TemplateRenderer.Render(template, root, "Microsoft.ContainerRegistry/registries");

        // "Domain name label scope" is the one genuinely unresolved field for this type (different
        // API surface); tenant/subscription identity is omitted from the body (already in
        // frontmatter); timestamps are deliberately reformatted, not reproduced verbatim (see
        // portal_timestamp) — every other captured value must still appear verbatim in the render.
        foreach (var (label, value) in fields.Where(f =>
            f.Label != "Domain name label scope"
            && !PortalFieldKnowledge.TenantIdentityAllowedValues.ContainsKey(f.Label)
            && !PortalFieldKnowledge.TimestampLabels.Contains(f.Label)))
        {
            Assert.Contains(value, rendered);
        }

        // "Creation date" is reformatted (see portal_timestamp), not reproduced verbatim — assert
        // the same UTC instant appears, derived from the raw capture rather than hardcoded, so this
        // doesn't need hand-updating every time the corpus is re-captured.
        var rawCreationDate = System.Text.Json.JsonDocument.Parse(File.ReadAllText(Path.Combine(dir, "data.json")))
            .RootElement.GetProperty("properties").GetProperty("creationDate").GetString()!;
        var expectedUtc = DateTimeOffset.Parse(rawCreationDate, null, System.Globalization.DateTimeStyles.AssumeUniversal);
        Assert.Contains(expectedUtc.ToString("HH:mm:ss"), rendered);
    }

    private static List<(string Label, string Value)> LoadPortalFields(string dir)
    {
        var path = Path.Combine(dir, "portal-fields.json");
        var fields = JsonSerializer.Deserialize<List<PortalFieldRecord>>(File.ReadAllText(path))!;
        return fields.Select(f => (f.Label, f.Value)).ToList();
    }

    private static JsonElement LoadResourceFromDir(string dir)
    {
        using var doc = JsonDocument.Parse(File.ReadAllText(Path.Combine(dir, "data.json")));
        return doc.RootElement.Clone();
    }

    private static JsonElement LoadCapturedResource(string category, string armTypeFolder)
    {
        var repoRoot = RepoPaths.ResolveRepoRoot();
        var dataJsonPath = Path.Combine(repoRoot, "output", category, armTypeFolder, "data.json");
        using var doc = JsonDocument.Parse(File.ReadAllText(dataJsonPath));
        return doc.RootElement.Clone();
    }
}

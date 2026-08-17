using System.Text.Json;
using System.Text.Json.Serialization;
using AzResourceDetailsDownloader.Provisioning;

namespace AzResourceDetailsDownloader.Config;

public static class ResourceTypeCatalogLoader
{
    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        Converters = { new JsonStringEnumConverter() }
    };

    public static ResourceTypeCatalog Load(string path)
    {
        if (!File.Exists(path))
        {
            throw new FileNotFoundException($"Resource type catalog not found at '{path}'.", path);
        }

        var json = File.ReadAllText(path);
        var catalog = JsonSerializer.Deserialize<ResourceTypeCatalog>(json, SerializerOptions)
            ?? throw new InvalidOperationException($"Catalog at '{path}' deserialized to null.");

        Validate(catalog, path);
        return catalog;
    }

    private static void Validate(ResourceTypeCatalog catalog, string path)
    {
        var seenArmTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var def in catalog.ResourceTypes)
        {
            if (!seenArmTypes.Add(def.ArmType))
            {
                throw new InvalidOperationException($"Duplicate armType '{def.ArmType}' in catalog '{path}'.");
            }

            if (string.IsNullOrWhiteSpace(def.NameTemplate))
            {
                throw new InvalidOperationException($"Resource type '{def.ArmType}' has an empty nameTemplate.");
            }

            // Prerequisites are provisioned in declared order, so a prerequisite may only reference aliases
            // declared earlier in the list (not itself, not ones declared after it).
            var aliasesDeclaredSoFar = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var prereq in def.Prerequisites)
            {
                if (aliasesDeclaredSoFar.Contains(prereq.Alias))
                {
                    throw new InvalidOperationException(
                        $"Duplicate prerequisite alias '{prereq.Alias}' under '{def.ArmType}'.");
                }

                if (string.IsNullOrWhiteSpace(prereq.NameTemplate))
                {
                    throw new InvalidOperationException(
                        $"Prerequisite '{prereq.Alias}' under '{def.ArmType}' has an empty nameTemplate.");
                }

                var prereqReferencedAliases = TemplateTokenResolver.FindPrereqAliasReferences(prereq.NameTemplate)
                    .Concat(TemplateTokenResolver.FindPrereqAliasReferences(prereq.RequestBody.GetRawText()));

                foreach (var alias in prereqReferencedAliases)
                {
                    if (!aliasesDeclaredSoFar.Contains(alias))
                    {
                        throw new InvalidOperationException(
                            $"Prerequisite '{prereq.Alias}' under '{def.ArmType}' references prerequisite alias " +
                            $"'{alias}', which must be declared earlier in the prerequisites list.");
                    }
                }

                aliasesDeclaredSoFar.Add(prereq.Alias);
            }

            var referencedAliases = TemplateTokenResolver.FindPrereqAliasReferences(def.NameTemplate)
                .Concat(TemplateTokenResolver.FindPrereqAliasReferences(def.RequestBody.GetRawText()));

            foreach (var alias in referencedAliases)
            {
                if (!aliasesDeclaredSoFar.Contains(alias))
                {
                    throw new InvalidOperationException(
                        $"Resource type '{def.ArmType}' references undeclared prerequisite alias '{alias}'.");
                }
            }
        }
    }
}

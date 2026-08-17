using System.Text;
using System.Text.Json;

namespace AzResourceDetailsDownloader.Provisioning;

public sealed class ArmResourceProvisioner(RawArmClient armClient)
{
    // Almost every ARM resource type accepts (and requires) a top-level "location" property, so it's
    // injected unconditionally by default — but a few sub-resource types explicitly reject it, inheriting
    // location from their parent instead. Live-verified for AKS agent pools: including "location" fails with
    // `UnmarshalError` / "unknown field \"location\"". Add more armTypes here if the same error shows up
    // elsewhere rather than assuming every resource type follows the common case.
    private static readonly HashSet<string> ArmTypesWithoutLocationProperty = new(StringComparer.OrdinalIgnoreCase)
    {
        "Microsoft.ContainerService/managedClusters/agentPools"
    };

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
        var includeLocation = !ArmTypesWithoutLocationProperty.Contains(armType);
        var body = BuildRequestBody(includeLocation ? location : null, requestBody);

        await armClient.PutAsync(resourceId.ToString(), apiVersion, body, provisioningTimeout, ct);

        return new ProvisionedResourceRef(resourceId.ToString(), name, location);
    }

    private static string BuildRequestBody(string? location, JsonElement requestBody)
    {
        using var stream = new MemoryStream();
        using (var writer = new Utf8JsonWriter(stream))
        {
            writer.WriteStartObject();
            if (location is not null)
            {
                writer.WriteString("location", location);
            }
            foreach (var property in requestBody.EnumerateObject())
            {
                property.WriteTo(writer);
            }
            writer.WriteEndObject();
        }

        return Encoding.UTF8.GetString(stream.ToArray());
    }
}

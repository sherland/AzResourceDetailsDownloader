using System.Text;
using Azure.Core;

namespace AzResourceDetailsDownloader.Provisioning;

public static class ResourceIdBuilder
{
    public static ResourceIdentifier Build(string subscriptionId, string resourceGroupName, string armType, string name)
    {
        var typeParts = armType.Split('/');
        var provider = typeParts[0];
        var typeSegments = typeParts[1..];
        var nameSegments = name.Split('/');

        if (typeSegments.Length != nameSegments.Length)
        {
            throw new InvalidOperationException(
                $"ArmType '{armType}' has {typeSegments.Length} type segment(s) but name '{name}' has {nameSegments.Length} segment(s).");
        }

        var path = new StringBuilder()
            .Append($"/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{provider}");

        for (var i = 0; i < typeSegments.Length; i++)
        {
            path.Append($"/{typeSegments[i]}/{nameSegments[i]}");
        }

        return new ResourceIdentifier(path.ToString());
    }
}

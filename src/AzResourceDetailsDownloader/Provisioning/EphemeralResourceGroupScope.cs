using Azure;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Resources;
using Microsoft.Extensions.Logging;

namespace AzResourceDetailsDownloader.Provisioning;

public sealed class EphemeralResourceGroupScope : IAsyncDisposable
{
    private readonly ResourceGroupResource _resourceGroup;
    private readonly ILogger _logger;

    private EphemeralResourceGroupScope(ResourceGroupResource resourceGroup, ILogger logger)
    {
        _resourceGroup = resourceGroup;
        _logger = logger;
    }

    public ResourceGroupResource ResourceGroup => _resourceGroup;

    public string Name => _resourceGroup.Data.Name;

    public static async Task<EphemeralResourceGroupScope> CreateAsync(
        ArmClient armClient,
        string subscriptionId,
        string name,
        string location,
        IReadOnlyDictionary<string, string> tags,
        ILogger logger,
        CancellationToken ct = default)
    {
        var subscription = armClient.GetSubscriptionResource(new ResourceIdentifier($"/subscriptions/{subscriptionId}"));

        var data = new ResourceGroupData(new AzureLocation(location));
        foreach (var tag in tags)
        {
            data.Tags[tag.Key] = tag.Value;
        }

        var operation = await subscription.GetResourceGroups().CreateOrUpdateAsync(WaitUntil.Completed, name, data, ct);
        return new EphemeralResourceGroupScope(operation.Value, logger);
    }

    public async ValueTask DisposeAsync()
    {
        try
        {
            await _resourceGroup.DeleteAsync(WaitUntil.Started);
        }
        catch (Exception ex)
        {
            _logger.LogError(
                ex,
                "Failed to delete ephemeral resource group '{Name}' — manual cleanup required (az group delete --name {Name} --yes --no-wait).",
                Name, Name);
        }
    }
}

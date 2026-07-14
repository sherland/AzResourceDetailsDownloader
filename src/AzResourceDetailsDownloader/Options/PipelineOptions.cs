namespace AzResourceDetailsDownloader.Options;

public sealed class PipelineOptions
{
    public string? TenantId { get; set; }
    public string? SubscriptionId { get; set; }
    public required string DefaultLocation { get; set; }
    public required string OutputRoot { get; set; }
    public required string CatalogPath { get; set; }
    public required string StorageStatePath { get; set; }
    public required string MaxCostTier { get; set; }
    public required string PortalBaseUrl { get; set; }
}

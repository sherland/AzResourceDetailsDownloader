namespace AzResourceDetailsDownloader.Capture;

public static class PortalUrlBuilder
{
    public static string BuildOverviewUrl(string portalBaseUrl, string tenantId, string resourceId) =>
        $"{portalBaseUrl.TrimEnd('/')}/#@{tenantId}/resource{resourceId}/overview";
}

namespace AzResourceDetailsDownloader.Output;

public static class ArmTypeKey
{
    public static string From(string armType) => armType.ToLowerInvariant().Replace('/', '_').Replace('.', '_');
}

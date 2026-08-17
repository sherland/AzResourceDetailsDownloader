namespace AzResourceDetailsDownloader.Provisioning;

public static class NameGenerator
{
    private const string LowerAlnumCharset = "abcdefghijklmnopqrstuvwxyz0123456789";
    private const string HexCharset = "0123456789abcdef";

    public static string RandomString(int length, string charsetKey, Random random) =>
        charsetKey switch
        {
            "lowerAlnum" => RandomFromCharset(length, LowerAlnumCharset, random),
            "lowerAlnumDash" => RandomAlnumWithSafeDashes(length, random),
            "hex" => RandomFromCharset(length, HexCharset, random),
            _ => throw new InvalidOperationException($"Unknown name charset '{charsetKey}'.")
        };

    private static string RandomFromCharset(int length, string charset, Random random)
    {
        var buffer = new char[length];
        for (var i = 0; i < length; i++)
        {
            buffer[i] = charset[random.Next(charset.Length)];
        }

        return new string(buffer);
    }

    // Many ARM resource types allow dashes but reject a leading/trailing dash or consecutive dashes
    // (e.g. Service Bus namespaces) — generate alnum-with-occasional-dash names that are always safe.
    private static string RandomAlnumWithSafeDashes(int length, Random random)
    {
        var buffer = new char[length];
        for (var i = 0; i < length; i++)
        {
            var canBeDash = i > 0 && i < length - 1 && buffer[i - 1] != '-';
            buffer[i] = canBeDash && random.Next(6) == 0
                ? '-'
                : LowerAlnumCharset[random.Next(LowerAlnumCharset.Length)];
        }

        return new string(buffer);
    }
}

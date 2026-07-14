namespace AzResourceDetailsDownloader.Cli;

public enum RunMode
{
    DryRun,
    Login,
    Run
}

public sealed record ParsedArgs(RunMode Mode, IReadOnlySet<string>? OnlyArmTypes, string? MaxCostTierOverride)
{
    public static ParsedArgs Parse(string[] args)
    {
        var mode = RunMode.DryRun;
        HashSet<string>? only = null;
        string? maxCostTier = null;

        for (var i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--login":
                    mode = RunMode.Login;
                    break;
                case "--run":
                    mode = RunMode.Run;
                    break;
                case "--dry-run":
                    mode = RunMode.DryRun;
                    break;
                case "--only":
                    only = RequireValue(args, ref i, "--only")
                        .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                        .ToHashSet(StringComparer.OrdinalIgnoreCase);
                    break;
                case "--max-cost-tier":
                    maxCostTier = RequireValue(args, ref i, "--max-cost-tier");
                    break;
                default:
                    throw new ArgumentException($"Unrecognized argument '{args[i]}'.");
            }
        }

        return new ParsedArgs(mode, only, maxCostTier);
    }

    private static string RequireValue(string[] args, ref int index, string flag)
    {
        if (index + 1 >= args.Length)
        {
            throw new ArgumentException($"Flag '{flag}' requires a value.");
        }

        index++;
        return args[index];
    }
}

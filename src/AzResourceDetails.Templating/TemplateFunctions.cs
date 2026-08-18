using System.Globalization;
using Scriban.Runtime;

namespace AzResourceDetails.Templating;

// Custom Scriban functions a generated template calls to reproduce the portal's friendly-text
// transforms (see PortalFieldKnowledge's FriendlyBoolWords / timestamp parsing / RegionDisplayNames
// — this is the inverse direction: formatting a raw ARM value, not parsing a captured portal one).
// Not part of vanilla Scriban or AzToMd — a template using these needs them registered on whatever
// engine renders it; TemplateRenderer.Render does this for ARDL's own self-validation pass. If a
// generated template is ever handed to a different renderer, that renderer needs to register the
// same four functions (documented in the comment header TemplateGenerator writes into every file).
public static class TemplateFunctions
{
    public static void ImportInto(ScriptObject globals)
    {
        globals.Import("portal_bool_enabled", new Func<bool?, string>(PortalBoolEnabled));
        globals.Import("portal_bool_yesno", new Func<bool?, string>(PortalBoolYesNo));
        globals.Import("portal_timestamp", new Func<string?, string>(PortalTimestamp));
        globals.Import("region_display_name", new Func<string?, string>(RegionDisplayName));
    }

    public static string PortalBoolEnabled(bool? value) => value switch
    {
        true => "Enabled",
        false => "Disabled",
        null => "",
    };

    public static string PortalBoolYesNo(bool? value) => value switch
    {
        true => "Yes",
        false => "No",
        null => "",
    };

    // One fixed, portal-plausible format ("August 13, 2026 at 14:50:31 UTC") rather than trying to
    // reproduce whichever of the portal's several observed shapes (GMT+n / (UTC) / bare UTC /
    // date-only / browser-local-with-no-marker — see PortalFieldKnowledge's timestamp parsing) a
    // specific label happened to use — the exact original format was itself locale/timezone-
    // dependent on the machine that captured it, not a fixed fact worth replicating precisely.
    public static string PortalTimestamp(string? isoValue)
    {
        if (string.IsNullOrEmpty(isoValue))
        {
            return "";
        }
        return DateTimeOffset.TryParse(isoValue, CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out var dto)
            ? dto.UtcDateTime.ToString("MMMM d, yyyy 'at' HH:mm:ss 'UTC'", CultureInfo.InvariantCulture)
            : isoValue;
    }

    public static string RegionDisplayName(string? code)
    {
        if (string.IsNullOrEmpty(code))
        {
            return "";
        }
        return RegionDisplayNames.TryGetDisplayName(code, out var display) ? display : code;
    }
}

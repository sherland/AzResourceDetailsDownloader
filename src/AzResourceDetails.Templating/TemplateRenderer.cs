using System.Text.Json;
using Scriban;
using Scriban.Runtime;

namespace AzResourceDetails.Templating;

// Renders a generated .sbn template against a real captured resource — ARDL's own self-validation
// pass, not a claim that this is how any other renderer (AzToMd or otherwise) would execute it.
// Registers the same TemplateFunctions every generated template's header comment documents needing.
public static class TemplateRenderer
{
    public static string Render(string templateText, JsonElement root, string armType)
    {
        var parsed = Template.Parse(templateText, "generated.sbn");
        if (parsed.HasErrors)
        {
            var errors = string.Join("; ", parsed.Messages.Select(m => m.ToString()));
            throw new InvalidOperationException($"Template for '{armType}' failed to parse: {errors}");
        }

        var model = ScribanModelBuilder.BuildModel(root, armType);
        var globals = new ScriptObject { ["model"] = model };
        TemplateFunctions.ImportInto(globals);

        var context = new TemplateContext();
        context.PushGlobal(globals);
        return parsed.Render(context);
    }
}

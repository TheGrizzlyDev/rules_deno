DenoAppProviderInfo = provider(
    doc = "A provider for an app, both info, configuration and source code",
    fields = {
        "main": "The entrypoint script of a deno app",
        "permissions": "A list of permissions for this app to run correctly",
        "importmap": "An import-map file as described by https://github.com/WICG/import-maps"
    }
)
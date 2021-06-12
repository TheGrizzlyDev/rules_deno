# rules_deno
#### a minimal set of rules for deno

## Usage
In order to use this set of rules you first need to start by setting everything up in your WORKSPACE file:

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_deno",
    urls = ["https://github.com/TheGrizzlyDev/rules_deno/archive/refs/tags/{version}.tar.gz".format(version = 0.1)],
)

load("@rules_deno//:deps.bzl", "deno_rules_dependencies", "deno_register_toolchains")

deno_rules_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

deno_register_toolchains()
```

Now you should be able to build a deno app. Currently the only rule that outputs anything is `deno_compile` which outputs an executable for your current platform (cross-compilation isn't supported yet).

You can declare a build in your BUILD file like this one:

```python
load("@rules_deno//:def.bzl", "deno_binary", "deno_library", "deno_app")

# A set of sources that constitutes your deno app
deno_library(
    name = "hello_with_deps_lib",
    srcs = [
        "dep.js"
    ]
)

deno_app(
    name = "hello_with_deps_app",
    # The main entrypoint to your application
    main = "index.js",
    # The sources your app depends on in order to build
    deps = [
        "hello_with_deps_lib"
    ],
    # Optional - a import-map file as per https://github.com/WICG/import-maps
    importmap = "import-map.json",

    # Optional - a list of permissions the app needs in order to run, as per https://deno.land/manual@v1.10.3/getting_started/permissions
    permissions = [
        "--allow-read",
        "--allow-write"
    ],
)

deno_binary(
    name = "hello_with_deps",
    app  = ":hello_with_deps_app",
)
```
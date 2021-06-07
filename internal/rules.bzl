load(":actions.bzl", "deno_compile")
load(":providers.bzl", "DenoAppProviderInfo")

def _deno_library_impl(ctx):
    return [
        DefaultInfo(files = depset(ctx.files.srcs, transitive = [dep[DefaultInfo].deps for dep in ctx.attr.deps])),
    ]

deno_library = rule(
    _deno_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = "Source files to compile",
        ),
        "deps": attr.label_list(
            providers = [DefaultInfo],
            doc = "Direct dependencies"
        )
    }
)

def _deno_app_impl(ctx):
    return [
        DefaultInfo(files = depset(transitive = [dep[DefaultInfo].files for dep in ctx.attr.deps])),
        DenoAppProviderInfo(
            main = ctx.file.main,
            permissions = ctx.attr.permissions,
            importmap = ctx.file.importmap
        )
    ]


deno_app = rule(
    _deno_app_impl,
    attrs = {
        "main": attr.label(
            allow_single_file = [".js", ".ts"],
            doc = "Source files to compile for the main package of this binary",
            mandatory = True
        ),
        "deps": attr.label_list(
            providers = [DefaultInfo],
            doc = "Direct dependencies"
        ),
        "permissions": attr.string_list(),
        "importmap": attr.label(allow_single_file = True)
    }
)

def _deno_binary_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name + "%/deno_binary")
    app = ctx.attr.app
    main = app[DenoAppProviderInfo].main
    srcs = [main] + ctx.attr.app[DefaultInfo].files.to_list()
    
    deno_compile(ctx, main, srcs, out)
    
    return [DefaultInfo(
        files = depset([out]),
        executable = out,
    )]


deno_binary = rule(
    _deno_binary_impl,
    attrs = {
        "app": attr.label(providers = [DenoAppProviderInfo, DefaultInfo])
    },
    doc = "Builds a deno bundle executable from js/ts source code",
    executable = True,
    toolchains = ["@rules_deno//:toolchain_type"],
)
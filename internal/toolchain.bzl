load("@bazel_skylib//lib:paths.bzl", "paths")
load(":actions.bzl", "deno_compile")

def _find_deno(tools):
    for tool in tools:
        if tool.path.endswith("deno") or tool.path.endswith("deno.exe"):
            return tool
    return None

def _deno_toolchain_impl(ctx):
    deno_exec = _find_deno(ctx.files.tools)
    if not deno_exec:
        fail("Cannot find deno command, please make sure the correct toolchain has been loaded")

    env = {
        "DENO_DIR": paths.dirname(deno_exec.path)
    }

    return [platform_common.ToolchainInfo(
        compile = deno_compile,
        internal = struct(
            deno = deno_exec,
            env = env,
        ),
    )]


deno_toolchain = rule(
    _deno_toolchain_impl,
    attrs = {
        "tools": attr.label(
            allow_single_file = True,
            doc = "Deno executable",
            mandatory = True
        )
    }
)
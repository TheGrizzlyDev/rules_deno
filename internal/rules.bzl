load("@bazel_skylib//:lib.bzl", "shell")

def _deno_binary_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name + "%/deno_binary")
    src = ctx.file.src
    deno_cmd = "/home/adistefano/.deno/bin/deno compile --output {out} {src}".format(
        out = shell.quote(out.path),
        src = shell.quote(src.path),
    )
    ctx.actions.run_shell(
        outputs                 = [out],
        inputs                  = [src],
        command                 = deno_cmd,
        mnemonic                = "DenoCompile"
    )
    return [DefaultInfo(
        files = depset([out]),
        executable = out,
    )]


deno_binary = rule(
    _deno_binary_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = [".js", ".ts"],
            doc = "Source files to compile for the main package of this binary",
            mandatory = True
        ),
    },
    doc = "Builds a deno bundle executable from js/ts source code",
    executable = True,
)
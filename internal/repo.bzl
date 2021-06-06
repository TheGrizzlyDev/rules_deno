def _deno_download(ctx):
    ctx.report_progress("downloading")

    ctx.download_and_extract(
        ctx.attr.urls,
        sha256 = ctx.attr.sha256,
    )

    if ctx.attr.os == "darwin":
        os_constraint = "@platforms//os:osx"
    elif ctx.attr.os == "linux":
        os_constraint = "@platforms//os:linux"
    elif ctx.attr.os == "windows":
        os_constraint = "@platforms//os:windows"
    else:
        fail("unsupported goos: " + ctx.attr.goos)
    if ctx.attr.arch == "amd64":
        arch_constraint = "@platforms//cpu:x86_64"
    elif ctx.attr.arch == "arm64":
        arch_constraint = "@platforms//cpu:aarch64"
    else:
        fail("unsupported arch: " + ctx.attr.goarch)
    constraints = [os_constraint, arch_constraint]
    constraint_str = ",\n        ".join(['"%s"' % c for c in constraints])


    substitutions = {
        "{os}": ctx.attr.os,
        "{arch}": ctx.attr.arch,
        "{exe}": ".exe" if ctx.attr.arch == "windows" else "",
        "{exec_constraints}": constraint_str,
        "{target_constraints}": constraint_str,
    }
    ctx.template(
        "BUILD.bazel",
        ctx.attr.template,
        substitutions = substitutions,
    )

deno_download = repository_rule(
    _deno_download,
    attrs = {
        "urls": attr.string_list(
            mandatory = True,
            doc = "List of mirror URLs for a Go distribution archive",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "Expected SHA-256 sum of the downloaded archive",
        ),
        "os": attr.string(
            mandatory = True,
            values = ["darwin", "linux", "windows"],
            doc = "Host operating system for the Deno distribution",
        ),
        "arch": attr.string(
            mandatory = True,
            values = ["amd64", "arm64"],
            doc = "Host architecture for the Deno distribution",
        ),
        "template": attr.label(
            default = "@rules_deno//internal:BUILD.dist.bazel.tpl"
        )
    }
)
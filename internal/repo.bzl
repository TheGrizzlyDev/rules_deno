def _map_arch(arch):
    if arch == "amd64":
        return "x86_64"
    elif arch == "arm64":
        return "aarch64"
    fail("Architecture %s is not supported yet." % arch)

def _build_os_constraints(os):
    if os == "darwin":
        return "@platforms//os:osx"
    elif os == "linux":
        return "@platforms//os:linux"
    elif os == "windows":
        return "@platforms//os:windows"
    else:
        fail("Unsupported OS: " + os)

def _build_arch_constraints(arch):
    if arch == "amd64":
        return "@platforms//cpu:x86_64"
    elif arch == "arm64":
        return "@platforms//cpu:aarch64"
    else:
        fail("Unsupported arch: " + arch)

def _build_constraints(os, arch):
    os_constraint = _build_os_constraints(os)
    arch_constraint = _build_arch_constraints(arch)

    constraints = [os_constraint, arch_constraint]
    return ",\n        ".join(['"%s"' % c for c in constraints])


def _deno_download(ctx):
    ctx.report_progress("Searching for a valid download link for deno")

    deno_os = ctx.attr.os
    deno_arch = _map_arch(ctx.attr.arch)
    deno_version = ctx.attr.deno_version

    download_cache = json.decode(ctx.read(ctx.attr._download_cache_json))
    download = download_cache["releases"][deno_version][deno_os][deno_arch]

    ctx.report_progress("Downloading deno")

    ctx.download_and_extract(
        [download["url"]],
        sha256 = download["sha256"],
    )

    
    constraints = _build_constraints(ctx.attr.os, ctx.attr.arch)


    substitutions = {
        "{exe}": ".exe" if ctx.attr.arch == "windows" else "",
        "{exec_constraints}": constraints,
        "{target_constraints}": constraints,
    }
    ctx.template(
        "BUILD.bazel",
        ctx.attr.template,
        substitutions = substitutions,
    )

deno_download = repository_rule(
    _deno_download,
    attrs = { 
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
        "deno_version": attr.string(
            mandatory = True,
            doc = "Deno version",
        ),
        "template": attr.label(
            default = "@rules_deno//internal:BUILD.dist.bazel.tpl"
        ),
        "_download_cache_json": attr.label(
            default = "@rules_deno//generated:deno-releases-cache.json"
        )
    }
)
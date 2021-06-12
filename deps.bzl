load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("//internal:repo.bzl", _deno_download = "deno_download")

deno_download = _deno_download

def deno_rules_dependencies():
    """Declares external repositories that rules_go_simple depends on. This
    function should be loaded and called from WORKSPACE files."""

    # bazel_skylib is a set of libraries that are useful for writing
    # Bazel rules. We use it to handle quoting arguments in shell commands.
    _maybe(
        git_repository,
        name = "bazel_skylib",
        remote = "https://github.com/bazelbuild/bazel-skylib",
        commit = "3fea8cb680f4a53a129f7ebace1a5a4d1e035914",
    )

def _maybe(rule, name, **kwargs):
    """Declares an external repository if it hasn't been declared already."""
    if name not in native.existing_rules():
        rule(name = name, **kwargs)

def deno_register_toolchains(name = "toolchain_deno", version = "v1.11.0"):
    deno_download(
        name = "%s_linux" % name,
        os = "linux",
        arch = "amd64",
        deno_version = version
    )

    deno_download(
        name = "%s_windows" % name,
        os = "windows",
        arch = "amd64",
        deno_version = version
    )

    deno_download(
        name = "%s_darwin_amd64" % name,
        os = "darwin",
        arch = "amd64",
        deno_version = version
    )

    deno_download(
        name = "%s_darwin_arm64" % name,
        os = "darwin",
        arch = "arm64",
        deno_version = version
    )

    native.register_toolchains(
        "@%s_linux//:toolchain" % name,
        "@%s_windows//:toolchain" % name,
        "@%s_darwin_amd64//:toolchain" % name,
        "@%s_darwin_arm64//:toolchain" % name,
    )
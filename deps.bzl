load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//internal:repo.bzl", _deno_download = "deno_download")

deno_download = _deno_download

def deno_rules_dependencies():
    """Declares external repositories that rules_go_simple depends on. This
    function should be loaded and called from WORKSPACE files."""

    # bazel_skylib is a set of libraries that are useful for writing
    # Bazel rules. We use it to handle quoting arguments in shell commands.

    _maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
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
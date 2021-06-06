load("@bazel_skylib//:lib.bzl", "shell")

def equals(name, target, expectation):
    native.sh_test(
        name = name,
        srcs = ["equals.sh"],
        args = ["$(location {})".format(target), shell.quote(expectation)],
        data = [target],
    )
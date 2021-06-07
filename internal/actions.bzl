def deno_run(ctx, arguments, outputs, inputs, mnemonic):
    toolchain = ctx.toolchains["@rules_deno//:toolchain_type"]
    return ctx.actions.run(
        outputs                 = outputs,
        inputs                  = inputs + [toolchain.internal.deno],
        arguments               = arguments,
        mnemonic                = mnemonic,
        executable              = toolchain.internal.deno,
        env                     = toolchain.internal.env,
    )


def deno_compile(ctx, main, srcs, out, importmap):
    full_srcs = srcs

    args = ctx.actions.args()
    args.add("compile")
    args.add("--output", out.path)
    
    if importmap:
        args.add("--import-map={}".format(importmap.path))
        full_srcs.append(importmap)

    args.add(main.path)

    deno_run(
        ctx                     = ctx,
        outputs                 = [out],
        inputs                  = full_srcs,
        arguments               = [args],
        mnemonic                = "DenoCompile",
    )
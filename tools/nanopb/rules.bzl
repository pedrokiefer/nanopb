def _GetPath(ctx, path):
  if ctx.label.workspace_root:
    return ctx.label.workspace_root + '/' + path
  else:
    return path

def _CcHdrs(srcs, use_grpc_plugin=False):
  ret = [s[:-len(".proto")] + ".nanopb.h" for s in srcs]
  return ret

def _CcSrcs(srcs, use_grpc_plugin=False):
  ret = [s[:-len(".proto")] + ".nanopb.c" for s in srcs]
  return ret

def _GenDir(ctx):
  return ctx.genfiles_dir.path + (
      "/" + ctx.attr.includes[0] if ctx.attr.includes and ctx.attr.includes[0] else "")

def _SourceDir(ctx):
  if not ctx.attr.includes:
    return ctx.label.workspace_root
  if not ctx.attr.includes[0]:
    return _GetPath(ctx, ctx.label.package)
  if not ctx.label.package:
    return _GetPath(ctx, ctx.attr.includes[0])
  return _GetPath(ctx, ctx.label.package + '/' + ctx.attr.includes[0])

def _proto_gen_impl(ctx):
  """General implementation for generating protos"""
  srcs = ctx.files.srcs
  deps = []
  deps += ctx.files.srcs
  options = []
  options += ctx.files.options
  source_dir = _SourceDir(ctx)
  gen_dir = _GenDir(ctx)
  if source_dir:
    import_flags = ["-I" + source_dir, "-I" + gen_dir]
  else:
    import_flags = ["-I."]

  for dep in ctx.attr.deps:
    import_flags += dep.proto.import_flags
    deps += dep.proto.deps

  args = []

  inputs = srcs + deps + options
  if ctx.executable.plugin:
    plugin = ctx.executable.plugin
    lang = ctx.attr.plugin_language
    if not lang and plugin.basename.startswith('protoc-gen-'):
      lang = plugin.basename[len('protoc-gen-'):]
    if not lang:
      fail("cannot infer the target language of plugin", "plugin_language")

    outdir = gen_dir
    if ctx.attr.plugin_options:
      outdir = ",".join(ctx.attr.plugin_options) + ":" + outdir
    args += ["--plugin=protoc-gen-%s=%s" % (lang, plugin.path)]
    args += ["--%s_out=%s" % (lang, outdir)]
    inputs += [plugin]

  if args:
    ctx.action(
        inputs=inputs,
        outputs=ctx.outputs.outs,
        arguments=args + import_flags + [s.path for s in srcs],
        executable=ctx.executable.protoc,
        mnemonic="ProtoCompile",
        use_default_shell_env=True,
    )

  return struct(
      proto=struct(
          srcs=srcs,
          import_flags=import_flags,
          deps=deps,
      ),
  )

proto_gen = rule(
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "options": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = ["proto"]),
        "includes": attr.string_list(),
        "protoc": attr.label(
            cfg = "host",
            executable = True,
            single_file = True,
            mandatory = True,
        ),
        "plugin": attr.label(
            cfg = "host",
            allow_files = True,
            executable = True,
        ),
        "plugin_language": attr.string(),
        "plugin_options": attr.string_list(),
        "gen_cc": attr.bool(),
        "gen_py": attr.bool(),
        "outs": attr.output_list(),
    },
    output_to_genfiles = True,
    implementation = _proto_gen_impl,
)
"""Generates codes from Protocol Buffers definitions.
This rule helps you to implement Skylark macros specific to the target
language. You should prefer more specific `cc_proto_library `,
`py_proto_library` and others unless you are adding such wrapper macros.
Args:
  srcs: Protocol Buffers definition files (.proto) to run the protocol compiler
    against.
  deps: a list of dependency labels; must be other proto libraries.
  includes: a list of include paths to .proto files.
  protoc: the label of the protocol compiler to generate the sources.
  plugin: the label of the protocol compiler plugin to be passed to the protocol
    compiler.
  plugin_language: the language of the generated sources
  plugin_options: a list of options to be passed to the plugin
  gen_cc: generates C++ sources in addition to the ones from the plugin.
  gen_py: generates Python sources in addition to the ones from the plugin.
  outs: a list of labels of the expected outputs from the protocol compiler.
"""

def cc_nanopb_library(
    name,
    srcs=[],
    options=[],
    deps=[],
    cc_libs=[],
    include=None,
    protoc=str(Label("@com_google_protobuf//:protoc")),
    default_runtime=str(Label("//nanopb:nanopb")),
    **kargs):
  """Bazel rule for creating a nanopb C library"""

  includes = []
  if include != None:
    includes = [include]

  gen_srcs = _CcSrcs(srcs)
  gen_hdrs = _CcHdrs(srcs)
  outs = gen_srcs + gen_hdrs

  proto_gen(
      name=name + "_genproto",
      srcs=srcs,
      options=options,
      deps=[s + "_genproto" for s in deps],
      includes=includes,
      protoc=protoc,
      plugin=str(Label("//generator:nanopb_plugin")),
      plugin_language="nanopb",
      outs=outs,
      visibility=["//visibility:public"],
  )

  if default_runtime and not default_runtime in cc_libs:
    cc_libs += [default_runtime]

  native.cc_library(
      name=name,
      srcs=gen_srcs,
      hdrs=gen_hdrs,
      deps=cc_libs + deps,
      includes=includes,
      **kargs)


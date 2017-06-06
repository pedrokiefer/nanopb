load("@com_google_protobuf//:protobuf.bzl", "proto_gen")

def _ccHdrs(srcs, use_grpc_plugin=False):
  ret = [s[:-len(".proto")] + ".pb.h" for s in srcs]
  return ret

def _ccSrcs(srcs, use_grpc_plugin=False):
  ret = [s[:-len(".proto")] + ".pb.c" for s in srcs]
  return ret

def cc_nanopb_library(
    name,
    srcs=[],
    deps=[],
    cc_libs=[],
    include=None,
    protoc=str(Label("@com_google_protobuf//:protoc")),
    default_runtime=str(Label("//:nanopb")),
    **kargs):
  """Bazel rule for creating a nanopb C library"""

  includes = []
  if include != None:
    includes = [include] 

  gen_srcs = _ccSrcs(srcs)
  gen_hdrs = _ccHdrs(srcs)
  outs = gen_srcs + gen_hdrs

  proto_gen(
      name=name + "_genproto",
      srcs=srcs,
      deps=[s + "_genproto" for s in deps],
      includes=includes,
      protoc=protoc,
      plugin="//generator:nanopb_plugin",
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


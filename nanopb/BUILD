licenses(["notice"])

package(default_visibility = ["//visibility:public"])

load("@com_google_protobuf//:protobuf.bzl", "py_proto_library")
load("//tools/nanopb:rules.bzl", "cc_nanopb_library")

cc_nanopb_library(
    name = "cc_nanopb_options",
    srcs = ["options.proto"],
    deps = ["@com_google_protobuf//:cc_wkt_protos"],
    include = "",
    visibility = ["//visibility:public"]
)

py_proto_library(
    name = "py_nanopb_options",
    srcs = ["options.proto"],
    deps = ["@com_google_protobuf//:protobuf_python"],
    protoc = "@com_google_protobuf//:protoc",
    default_runtime = "@com_google_protobuf//:protobuf_python",
    visibility = ["//visibility:public"],
    srcs_version = "PY2AND3",
)

cc_library(
  name = "nanopb",
  visibility = ["//visibility:public"],
  hdrs = [
    "pb.h",
    "pb_common.h",
    "pb_decode.h",
    "pb_encode.h",
  ],
  srcs = [
    "pb_common.c",
    "pb_decode.c",
    "pb_encode.c",
  ],
  includes = ["."],
)

cc_library(
  name = "nanopb_with_malloc",
  visibility = ["//visibility:public"],
  hdrs = [
    "pb.h",
    "pb_common.h",
    "pb_decode.h",
    "pb_encode.h",
  ],
  srcs = [
    "pb_common.c",
    "pb_decode.c",
    "pb_encode.c",
  ],
  copts = [
    "-DPB_ENABLE_MALLOC=1",
    "-DPB_SYSTEM_HEADER=\\\"malloc_wrappers_syshdr.h\\\"",
  ],
  includes = ["."],
)

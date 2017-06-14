load("@com_google_protobuf//:protobuf.bzl", "py_proto_library")
load("//tools/nanopb:rules.bzl", "cc_nanopb_library")

cc_nanopb_library(
	name = "nanopb",
	srcs = ["nanopb.proto", ],
	deps = ["@com_google_protobuf//:cc_wkt_protos"],
	include = "",
	visibility = ["//visibility:public"]
)

py_proto_library(
    name = "py_proto_nanopb",
    srcs = ["nanopb.proto"],
    deps = ["@com_google_protobuf//:protobuf_python"],
    protoc = "@com_google_protobuf//:protoc",
    default_runtime = "@com_google_protobuf//:protobuf_python",
    visibility = ["//visibility:public"],
)

py_proto_library(
    name = "py_proto_plugin",
    srcs = ["plugin.proto"],
    deps = ["@com_google_protobuf//:protobuf_python"],
    protoc = "@com_google_protobuf//:protoc",
    default_runtime = "@com_google_protobuf//:protobuf_python",
    visibility = ["//visibility:public"],
)
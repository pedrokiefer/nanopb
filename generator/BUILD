load("@com_google_protobuf//:protobuf.bzl", "py_proto_library")

py_proto_library(
    name = "nanopb_options",
    srcs = ["nanopb/options.proto"],
    deps = ["@com_google_protobuf//:protobuf_python"],
    protoc = "@com_google_protobuf//:protoc",
    default_runtime = "@com_google_protobuf//:protobuf_python",
)

py_library(
    name = "proto",
    srcs = glob(["proto/**/*.py"]),
    deps = [
        "@com_google_protobuf//:protobuf_python",
        "@six_archive//:six",
    ],
)

py_proto_library(
    name = "proto_nanopb",
    srcs = ["proto/nanopb.proto"],
    deps = ["@com_google_protobuf//:protobuf_python"],
    protoc = "@com_google_protobuf//:protoc",
    default_runtime = "@com_google_protobuf//:protobuf_python",
)

py_proto_library(
    name = "proto_plugin",
    srcs = ["proto/plugin.proto"],
    deps = ["@com_google_protobuf//:protobuf_python"],
    protoc = "@com_google_protobuf//:protoc",
    default_runtime = "@com_google_protobuf//:protobuf_python",
)

py_binary(
    name = "nanopb_plugin",
    srcs = ["nanopb_generator.py"],
    deps = [":proto", ":nanopb_options", ":proto_nanopb", ":proto_plugin"],
    main = "nanopb_generator.py",
    visibility = ["//visibility:public"],
)



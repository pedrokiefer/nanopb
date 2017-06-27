py_library(
    name = "proto",
    srcs = glob(["proto/**/*.py"]),
    deps = [
        "@com_google_protobuf//:protobuf_python",
        "@six_archive//:six",
    ],
    srcs_version = "PY2AND3",
)

py_binary(
    name = "nanopb_plugin",
    srcs = ["nanopb_generator.py"],
    deps = [":proto", "//nanopb:py_nanopb_options", "//generator/proto:py_proto_nanopb", "//generator/proto:py_proto_plugin"],
    main = "nanopb_generator.py",
    visibility = ["//visibility:public"],
    srcs_version = "PY2AND3",
)



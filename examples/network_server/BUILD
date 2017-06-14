load("//tools/nanopb:rules.bzl", "cc_nanopb_library")

cc_nanopb_library(
    name = "fileproto",
    srcs = ["fileproto.proto"],
    options = ["fileproto.options"],
)

cc_library(
	name = "common",
	srcs = ["common.c"],
	hdrs = ["common.h"],
	deps = ["//nanopb:nanopb"],
)

cc_binary(
	name = "client",
	srcs = ["client.c"],
	deps = [":fileproto", ":common"],
)

cc_binary(
	name = "server",
	srcs = ["server.c"],
	deps = [":fileproto", ":common"],
)
load("//tools/nanopb:rules.bzl", "cc_nanopb_library")

cc_nanopb_library(
    name = "nanopb_simple",
    srcs = ["simple.proto"],
)

cc_binary(
	name = "simple",
	srcs = ["simple.c"],
	deps = [":nanopb_simple"],
)
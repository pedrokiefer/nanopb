workspace(
   name = "fi_kapsi_jpa_nanopb"
)

http_archive(
   name = "com_google_protobuf",
   url = "https://github.com/google/protobuf/archive/v3.3.0.zip",
   strip_prefix = "protobuf-3.3.0",
   sha256 = "ab499973b61293571964b87f7615d262384e82ee969642c07a0b26013059d712",
)

new_http_archive(
    name = "six_archive",
    build_file = "six.BUILD",
    sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a",
    url = "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz#md5=34eed507548117b2ab523ab14b2f8b55",
)

bind(
    name = "six",
    actual = "@six_archive//:six",
)

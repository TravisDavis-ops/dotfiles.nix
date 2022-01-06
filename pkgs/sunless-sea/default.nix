{ builders, ... }@inputs: let b =
builders.mkNixGame {
  pname = "sunless-sea";
  iname = "sunless_sea";
  version = "2_2_7_3165_29003";
  sha256 = "1y9jvnmz1d99jzzpvy4bv3xnkdgxv2pg8z8hwlpld7pkx1pnkmsz";
}; in b (inputs)

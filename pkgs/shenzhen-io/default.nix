{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "shenzhen-io";
    iname = "shenzhen_i_o_gog";
    version = "3_11_14_2020_43142";
    sha256 = "17xpw6zihiacv3k0c6yw9a641mqf1hhiidq4hm9052z9irr3jjb8";
  }; in b (inputs)

{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "kentucky-route-zero";
    iname = "kentucky_route_zero_pc_edition_eastman_sea_rover";
    version = "c_35855";
    sha256 = "00lk7h2wvzdv0mjfv46wa1rh64ci860fb4w8xsd42gbjmwfaqnvr";
  }; in b (inputs)

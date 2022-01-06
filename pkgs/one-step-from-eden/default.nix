{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "one-step-from-eden";
    iname = "one_step_from_eden";
    bname = "osfe";
    version = "1_6_2_47040";
    sha256 = "0l7h82c4r4vby6p4nnb4mx5jbb3d95yf4rc0gqk1y615hs0gmggj";
  }; in b (inputs)

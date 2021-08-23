{ lib, builders }:
builders.mkGogPackage {
  pname = "one-step-from-eden";
  version = "1_6_2_47040";
  installerName = "one_step_from_eden";
  sha256 = "0l7h82c4r4vby6p4nnb4mx5jbb3d95yf4rc0gqk1y615hs0gmggj";
  binName = "osfe";
}

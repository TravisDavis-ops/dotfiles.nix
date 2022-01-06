{ builders, ... }@inputs: let b =
builders.mkNixGame {
  pname = "huniecam-studio";
  iname = "huniecam_studio";
  version = "1_0_2_51825";
  sha256 = "094wzma4iqa22bv3nbvx387ffiz62irqcw9rcnqr2bp8vic5hj1g";
}; in b (inputs)

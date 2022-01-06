{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "torchlight-2";
    iname = "gog_torchlight_2";
    version = "2.0.0.2";
    sha256 = "1669d1apmnv1fp1w6ksm383983l84nsz0svxrd195x93skvcfl5f";
  }; in b (inputs)

{ builders, ... }@inputs:
let b =
  #TODO(update)
  builders.mkNixGame {
    pname = "stardew-valley";
    iname = "stardew_valley";
    version = "1_5_4_1396293314_48235";
    sha256 = "05n85rbz27whn7d60ym1v4k3h587g9xh9g4aw8f9whgkwgbnnwd3";
  }; in b (inputs)

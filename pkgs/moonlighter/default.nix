{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "moonlighter";
    version = "1_14_38_48229";
    sha256 = "09mp93zy6kkh2qs3wl7pmfnk7wqr6a1b055h27q9vc06xvm0390c";
  }; in b (inputs)

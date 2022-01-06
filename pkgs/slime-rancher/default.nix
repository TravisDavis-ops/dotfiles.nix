{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    #TODO(wrap in sh script to force set SDL_VIDOEDRIVER to x11)
    pname = "slime-rancher";
    iname = "slime_rancher";
    version = "1_4_3_43304";
    sha256 = "1gwia1qfb36fwyf4k8mhz02fv8nis7c2jlq2z4020mwm5wc4jq41";
  }; in b (inputs)

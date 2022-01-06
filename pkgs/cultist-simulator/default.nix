{ builders, ... }@inputs:
let b =
  builders.mkNixGame rec {
    pname = "cultist-simulator";
    iname = "cultist_simulator_2021";
    version = "1_b_2_44604";
    sha256 = "16gqmaah8wq5l7i1d81scp2vzll1iaafr7g48pzjym8ibzm04a4b";
    fixup = "sed -i 's/CS.x86/CS.x86_64/' $out/share/${pname}/data/noarch/start.sh";
  }; in b (inputs)

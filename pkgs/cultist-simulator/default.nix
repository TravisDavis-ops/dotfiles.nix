{ lib, ... }:
lib.builders.mkGogPackage {
  pname = "cultist-simulator";
  version = "1_b_2_44604";
  installerName = "cultist_simulator_2021";
  sha256 = "16gqmaah8wq5l7i1d81scp2vzll1iaafr7g48pzjym8ibzm04a4b";
  binName = "cultist-simulator";
  fixup = ''
    sed -i 's/CS.x86/CS.x86_64/' $out/share/data/noarch/start.sh
  '';
}

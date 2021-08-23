{ lib, ... }:
lib.builders.mkGogPackage {
  pname = "slay-the-spire";
  version = "8735c9fe3cc2280b76aa3ec47c953352a7df1f65_43444";
  installerName = "slay_the_spire_2020_12_15";
  sha256 = "0miq71vjjm44cl9vlr12qfkq0336rq28q55jrp8zz3f45j4qhygn";
  binName = "slay-the-spire";
  fixup = ''
    sed -i "s/jre\/bin\/java/SlayTheSpire/" $out/share/data/noarch/start.sh
  '';
}

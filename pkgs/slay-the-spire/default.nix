{ builders, ... }@inputs: let b =
builders.mkNixGame rec {
  #TODO(Missing Config file, trys to write a default one to readonly area)
  pname = "slay-the-spire";
  iname = "slay_the_spire_2020_12_15";
  version = "8735c9fe3cc2280b76aa3ec47c953352a7df1f65_43444";
  sha256 = "0miq71vjjm44cl9vlr12qfkq0336rq28q55jrp8zz3f45j4qhygn";
  fixup = "sed -i 's/jre\/bin\/java/SlayTheSpire/' $out/share/${pname}/data/noarch/start.sh";
}; in b (inputs)

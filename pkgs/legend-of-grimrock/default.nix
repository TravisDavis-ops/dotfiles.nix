{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "legend-of-grimrock";
    iname = "gog_legend_of_grimrock";
    bname = "legend-of-grimrock";
    version = "2.1.0.5";
    sha256 = "1w8sgmifkijbpic30bx211yj4lgiank15gj5klwg8kbyjxj11yn5";
  }; in b (inputs)

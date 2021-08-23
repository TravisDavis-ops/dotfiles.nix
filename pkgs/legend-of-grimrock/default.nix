{ lib, builders }:
builders.mkGogPackage {
  pname = "legend-of-grimrock";
  version = "2.1.0.5";
  installerName = "gog_legend_of_grimrock";
  sha256 = "1w8sgmifkijbpic30bx211yj4lgiank15gj5klwg8kbyjxj11yn5";
  binName = "legend-of-grimrock";
}

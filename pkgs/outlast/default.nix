{ lib, builders }:
builders.mkGogPackage {
  pname = "outlast";
  version = "2.0.0.2";
  installerName = "gog_outlast";
  sha256 = "1dh52wy1jgb1akl23wmdds7hmj12cmffrakla9954lfprslibyyq";
  binName = "outlast";
}

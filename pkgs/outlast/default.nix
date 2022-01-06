{ builders, ... }@inputs: let b =
builders.mkNixGame {
  pname = "outlast";
  iname = "gog_outlast";
  version = "2.0.0.2";
  sha256 = "1dh52wy1jgb1akl23wmdds7hmj12cmffrakla9954lfprslibyyq";
}; in b (inputs)

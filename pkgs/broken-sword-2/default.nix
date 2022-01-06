{ builders, ... }@inputs: let b =
builders.mkNixGame {
  pname = "broken-sword-2-remastered";
  iname = "gog_broken_sword_2_remastered";
  bname = "broken-sword-2";
  version = "2.0.0.3";
  sha256 = "";
}; in b (inputs)

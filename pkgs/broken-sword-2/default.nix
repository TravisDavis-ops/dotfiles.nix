{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "broken-sword-2-remastered";
    iname = "gog_broken_sword_2_remastered";
    bname = "broken-sword-2";
    version = "2.0.0.3";
    sha256 = "02wgs2r3ki9y36xd2n7w9i8i7269l62hp32j906wwn0hgg3f3f0m";
  }; in b (inputs)

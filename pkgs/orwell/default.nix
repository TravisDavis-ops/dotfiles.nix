{ builders, ... }@inputs: let b =
builders.mkNixGame {
  pname = "orwell";
  version = "1_4_7424_39231";
  sha256 = "0nkpiq8n7lsb9g8dka2m1n0sjmqs37b8zn2nxny7l8326xaqxza4";
}; in b (inputs)

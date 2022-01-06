{ builders, ... }@inputs: let b =
builders.mkNixGame {
  pname = "orwell-iis";
  iname = "orwell_ignorance_is_strength_en";
  version = "1_1_6771_23686_22333";
  sha256 = "1k0x7gxmgjclzf9ykbs8ydyvqpr1a9dv2ycrlqly4fch6dpxbhq4";
}; in b (inputs)

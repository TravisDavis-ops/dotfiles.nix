{ builders, ... }@inputs:
let b =
  builders.mkNixGame {
    pname = "megaquarium";
    version = "v2_2_4g_47771";
    sha256 = "1pcaby0dmqqrmx6nzvbgqmrc3a6634scpm05wcqd22r6q74fjx8y";
  }; in b (inputs)

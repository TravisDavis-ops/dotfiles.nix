{ buildGoModule, fetchFromGitHub,...}: buildGoModule rec {
  pname = "mangodl";
  version = "1.5";
  src = fetchFromGitHub {
    owner = "Gyro7";
    repo = pname;
    rev = "mangodl-v${version}-linux";
    sha256 = "sha256-xFunXwu8S+/C21L1smPEosZHfJe3v54DbVhxOMI0ygw=";
  };
  vendorSha256 ="sha256-ceARb7TlTmLpMfLESlO2OJvGDY4a1biFwJRyu2/67/o=";
  runVend = false;
}

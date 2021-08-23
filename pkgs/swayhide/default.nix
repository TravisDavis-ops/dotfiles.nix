{ lib, rustPlatform, fetchFromGitHub, ... }:
rustPlatform.buildRustPackage rec {
  pname = "swayhide";
  version = "v0.2.0";
  cargoLock = { lockFile = ./Cargo.lock; };
  src = fetchFromGitHub {
    owner = "NomisIV";
    repo = pname;
    rev = version;
    sha256 = "sha256-yn2vXKRQKdNC69F1Ofz0Vye45pia0cXmFTlT9otUAVE=";
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoSha256 = "sha256-YWCDPZ7tE9wnscaP2lgoCJc/UiQ/QAuIkxi/l/Ua2zY=";
  #cargoHash = lib.fakeHash;
  doCheck = false;
  meta = with lib; {
    description = "A window swallower for sway";
    homepage = "https://github.com/NomisIV/swayhide";
    license = licenses.mit;
    maintainers = [ maintainers.tailhook ];
  };
}

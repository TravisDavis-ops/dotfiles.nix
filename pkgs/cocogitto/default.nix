{ lib, rustPlatform, fetchFromGitHub, ... }:
rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "4.0.1";
  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-uSKzHo1lEBiXsi1rOKvfD2zVlkAUVZ5k0y8iiTXYE2A=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  #postPatch = ''
  #  cp ${./Cargo.lock} Cargo.lock
  #'';
  doCheck = false;
  meta = with lib; {
    description =
      "Cocogitto is a set of cli tools for the conventional commit and semver specifications.";
    homepage = "https://github.com/oknozor/cocogitto.git";
    license = licenses.mit;
    maintainers = [ ];
  };
}

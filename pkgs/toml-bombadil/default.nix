{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage rec {
  pname = "toml-bombadil";
  version = "2.0.0";
  #cargoLock = toString ./Cargo.lock;
  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-N4jzn4x/sxugYFFL86PfC+Zs+K62ayFW096UV+S/Sag=";
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoSha256 = lib.fakeSha256;
  #cargoHash = lib.fakeHash;
  doCheck = false;
  meta = with lib; {
    description = "A dotfile manager";
    homepage = "https://oknozor.github.io/toml-bombadil/";
    license = licenses.mit;
    maintainers = [ maintainers.tailhook ];
  };
}

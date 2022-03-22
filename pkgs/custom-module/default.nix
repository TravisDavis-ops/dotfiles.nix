{ lib, git, openssl, pkg-config, installShellFiles, makeWrapper, rustPlatform, fetchFromGitea, ... }:
rustPlatform.buildRustPackage rec {
  pname = "custom_module";
  name = "custom_module";
  version = "v0.0.1";
  src = fetchFromGitea{
    domain = "git.tdavis.dev";
    owner = "xiro49";
    repo = pname;
    rev = version;
    sha256 = "sha256-Xj1GIb4Cr0RB7CCTveJgoxah7YRjUPYyxRRTUrM/Bx0=";
  };
   PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  doCheck = false;
  nativeBuildInputs = [ openssl pkg-config];
  meta = with lib; {
    description =
      "Custom Module for Waybar";
    homepage = "https://git.tdavis.dev/xiro49/custom_module";
    license = licenses.mit;
    maintainers = [ ];
  };
}

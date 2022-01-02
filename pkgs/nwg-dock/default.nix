{ buildGoModule, fetchFromGitHub, pkg-config, go, gtk3, gtk-layer-shell, ... }: buildGoModule rec {
  pname = "nwg-dock";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HA63z7FVGG4feHM8oRNid+jtpm6IVFPyu4TrKdDrLt4=";
  };
  vendorSha256 = "sha256-rz2z7k6yTtZGlCRwiLVQwCGM1WS+HVffIwl7uV+8ARw=";
  buildInputs = [ go gtk3 gtk-layer-shell ];
  nativeBuildInputs = [ pkg-config ];
  postInstall = ''
    mkdir -p $out/share/${pname};
    cp -r $src/images $out/share/${pname}
    cp $src/config/* $out/share/${pname}
  '';
}

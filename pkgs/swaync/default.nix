{ lib
, meson
, ninja
, vala
, gtk3
, libhandy
, json-glib
, gir-rs
, gtk-layer-shell
, gobject-introspection
, stdenv
, fetchFromGitHub
, ... }:
stdenv.mkDerication {
  pname = "swayhide";
  version = "v0.2.0";
  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = null;
    sha256 = " ";
  };

  buildInputs = with pkgs; [
    gtk3
    libhandy
    json-glib
    gir-rs
    gtk-layer-shell
    gobject-introspection
  ];
  nativeBuildInputs = with pkgs; [
    meson
    ninja
    vala
    pkg-config
  ];
  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = [ maintainers.tailhook ];
  };
}

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
, pkg-config
, stdenv
, fetchFromGitHub
, ...
}:
stdenv.mkDerivation {
  pname = "swayhide";
  version = "v0.1.0";
  src = fetchFromGitHub {
    owner = "TravisDavis-ops";
    repo = "SwayNotificationCenter";
    rev = "v0.1.0";
    sha256 = "sha256-xo+M8dpqs2tbWQn49PR5ms3TlzMsv9SvY/QN7Jb/MT4=";
  };

  buildInputs = [
    gtk3
    libhandy
    json-glib
    gir-rs
    gtk-layer-shell
    gobject-introspection
  ];

  nativeBuildInputs = [
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

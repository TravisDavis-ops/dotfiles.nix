{ pkgs, ... }:
pkgs.mkShell {
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
}

{ lib, ... }:
lib.builders.mkGogPackage {
  pname = "dont-starve";
  version = "4294041_41439";
  installerName = "don_t_starve";
  sha256 = "0pnifv6qj62z338m0pzg2gqyqhjms2hszghkrqfzry2p9jfinyw0";
  binName = "dont-starve";
  fixup = ''
    # dont use the shit it brought
    substitute $out/share/$name/data/noarch/game/bin/dontstarve.sh  \
               $out/share/$name/data/noarch/game/bin/dontstarve.sh  \
               --replace export "#export"

    # sorry you dont need write access to your own files
    substitute $out/share/$name/data/noarch/start.sh  \
               $out/share/$name/data/noarch/start.sh  \
               --replace chmod "#chmod"

    # dosnt like wayland
    sed -i '2s/^/SDL_VIDEODIRVER=x11\n/' $out/share/$name/data/noarch/game/bin/dontstarve.sh
  '';
}

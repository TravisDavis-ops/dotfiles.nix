{ builders, ... }@inputs:
let b =
  builders.mkNixGame rec {
    pname = "dont-starve";
    iname = "don_t_starve";
    version = "4294041_41439";
    sha256 = "0pnifv6qj62z338m0pzg2gqyqhjms2hszghkrqfzry2p9jfinyw0";
    fixup = ''
      # dont use the libs included
      substituteInPlace $out/share/${pname}/data/noarch/game/bin/dontstarve.sh --replace export "#export"
      # force SDL_VIDEODIRVER to x11
      sed -i '2s/^/SDL_VIDEODIRVER=x11\n/' $out/share/${pname}/data/noarch/game/bin/dontstarve.sh
    '';
  }; in b (inputs)

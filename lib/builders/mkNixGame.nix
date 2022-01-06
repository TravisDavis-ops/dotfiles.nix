{...}:
{ pname # package name
, iname ? pname # installer name
, bname ? pname # bin name
, version # version string
, sha256 # for the installer
, fixup ? "" # package speciic fixup
, inputs ? [] # build Inputs
, meta ? { }
, ... }@args:
{ stdenvNoCC, requireFile, zip, unzip, makeWrapper, steam-run, ... }@pkgs:
stdenvNoCC.mkDerivation {
  name = "${pname}-${version}";
  src = requireFile {
    inherit sha256;
    name = "${iname}_${version}.sh";
    message = ''
      Please purchase the game on gog.com and download the linux installer.
      once you have downloaded the file, please use the following command and re-run the installation:
        nix-prefetch-url file://\$PWD/${iname}_${version}.sh
    '';
  };

  nativeBuildInputs = [ zip unzip makeWrapper ];
  buildInputs = [ steam-run ];

  sourceRoot = "source";

  unpackPhase = ''
    zip -F $src --out fixed.zip
    unzip -d source fixed.zip
    substituteInPlace source/data/noarch/start.sh --replace chmod "#chmod"
  '';

  buildPhase = ''
    # no point its always readonly no issues so far
    mkdir -p $out/share/${pname}
    cp -r * $out/share/${pname}
  '';

  installPhase = ''
    makeWrapper ${steam-run}/bin/steam-run $out/bin/${bname} --add-flags $out/share/${pname}/data/noarch/start.sh
  '';

  fixupPhase = fixup;
  meta = meta;
}

{ ... }:
{ pname
, iname ? pname
, bname ? pname
, ename ? pname
, version
, sha256
, fixup ? ""
, inputs ? [ ]
, meta ? { }, }:
{ stdenv, requireFile, zip, unzip, makeWrapper, wine64, innoextract, ... }:
stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = requireFile {
    inherit sha256;
    name = "setup_${iname}_${version}.exe";
    message = ''
      Please purchase the game on gog.com and download the installer.
      once you have downloaded the file, please use the following command and re-run the installation:
      the output of the command is your sha256 please replace your sha256 if your running into trouble
      <nix-prefetch-url file://\$PWD/setup_${iname}_${version}.exe>
    '';
  };
  nativeBuildInputs = [ ];
  buildInputs = [ wine64 innoextract  makeWrapper ];

  unpackPhase = ''
    pwd
    mkdir -p gamefiles
    ${innoextract}/bin/innoextract --output-dir gamefiles --extract --gog $src
  '';

  buildPhase = ''
    mkdir -p $out/share/${pname}
    cp -r gamefiles/* $out/share/${pname}
  '';

  installPhase = ''
    makeWrapper ${wine64}/bin/wine64 $out/bin/${bname} --add-flags $out/share/${pname}/${ename}.exe
  '';

  fixupPhase = fixup;
  meta = meta;
}

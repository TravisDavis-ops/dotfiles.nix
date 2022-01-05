{ ...}:
{ binName, installerName, tname, pname, version, sha256, fixup ? "", meta ? { }, }:
{ stdenv, requireFile, zip, unzip, makeWrapper, wine, innoextract, ... }:
stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = requireFile {
    inherit sha256;
    name = "setup_${installerName}_${version}.sh";
    message = ''
      Please purchase the game on gog.com and download the installer.
      once you have downloaded the file, please use the following command and re-run the installation:
      the output of the command is your sha256 please replace your sha256 if your running into trouble
      <nix-prefetch-url file://\$PWD/setup_${installerName}_${version}.sh>
    '';
  };
  nativeBuildInputs = [ innoextract makeWrapper ];
  buildInputs = [ wine ];
  sourceRoot = "source";

  unpackPhase = ''
    innoextract --extract --output-dir source $src
  '';

  buildPhase = ''
    mkdir -p $out/share/${pname}
    cp -r source $out/share/${pname}
  '';

  installPhase = ''
    makeWrapper ${wine}/bin/wine $out/bin/${binName} --add-flags $out/share/${pname}/${tname}.exe
  '';

  fixupPhase = fixup;
  meta = meta;
}

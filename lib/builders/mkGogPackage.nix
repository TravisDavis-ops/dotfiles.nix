{ binName, installerName, pname, version, sha256, fixup ? "", meta ? { }, }:
{ stdenv, requireFile, zip, unzip, makeWrapper, steam-run, curl, ... }:
let
  #TODO( expose buildInputs )
  curlWithGnuTls = curl.override { gnutlsSupport = true; opensslSupport = false; }; # dont starve needed this
in stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = requireFile {
    inherit sha256;
    name = "${installerName}_${version}.sh";
    message = ''
      Please purchase the game on gog.com and download the linux installer.
      once you have downloaded the file, please use the following command and re-run the installation:
        nix-prefetch-url file://\$PWD/${installerName}_${version}.sh
    '';
  };
  nativeBuildInputs = [ zip unzip makeWrapper ];
  buildInputs = [ steam-run curlWithGnuTls ];
  unpackPhase = ''
    zip -F $src --out fixed.zip
    unzip -d source fixed.zip
  '';
  sourceRoot = "source";
  buildPhase = ''
    mkdir -p $out/share/$name
    cp -r * $out/share/$name
  '';
  installPhase = ''
    makeWrapper ${steam-run}/bin/steam-run $out/bin/${binName} --add-flags $out/share/$name/data/noarch/start.sh
  '';
  fixupPhase = fixup;
  meta = meta;
}

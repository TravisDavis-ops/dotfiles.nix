{ lib, stdenv, buildDotnetModule, dotnetCorePackages,fetchFromGitHub, ...}:
buildDotnetModule rec {
    pname = "kavita";
    version = "0.4.9";
    src = fetchFromGitHub {
        owner = "Kareadita";
        repo = pname;
        rev = version;
        sha256 = "";
    };
    projectFile = "src/Kavita.sln";
    buildType = "Release";
    dotnet-sdk = dotnetCorePackages.sdk_3_1;
    dotnet-runtime = dotnetCorePackages.net_6_0;
    dotnetBuildFlags = [  ];
  meta = with lib; {
    description = "Kavita is a fast, feature rich, cross platform reading server. Built with a focus for manga and the goal of being a full solution for all your reading needs. Setup your own server and share your reading collection with your friends and family. ";
    homepage = "https://www.kavitareader.com/";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}



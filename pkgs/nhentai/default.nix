{ lib, pythonPackages, ...}:
pythonPackages.buildPythonApplication rec {
  pname = "nhentai";
  version = "0.4.16";
  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-2lzrQqUx3lPM+OAUO/SwT+fAuG7kWmUnTACNUiP7d1M=";
  };
  propagatedBuildInputs = with pythonPackages; [
    requests
    iso8601
    beautifulsoup4
    soupsieve
    tabulate
    tabulate
    future
  ];
  meta = with lib; {
    homepage = "https://github.com/RicterZ/nhentai";
    description =
      "nHentai is a CLI tool for downloading doujinshi from <http://nhentai.net>";
    license = licenses.mit;
    maintainers = with maintaners; [ ];
  };
}

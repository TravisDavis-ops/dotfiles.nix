{ lib, pythonPackages, ... }:
pythonPackages.buildPythonApplication rec {
  pname = "xxh-xxh";
  version = "0.8.7";
  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-NggUTiA1t9Oookhzs9106htEYIkpceJlUG/UYnStKXM=";
  };
  propagatedBuildInputs = with pythonPackages; [
    pexpect
    pyyaml
  ];
  meta = with lib; {
    homepage = "https://github.com/xxh/xxh";
    description = "🚀 Bring your favorite shell wherever you go through the ssh.";
    license = licenses.bsd2;
    maintainers = with maintaners; [ ];
  };
}

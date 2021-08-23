{ stdenv, lib, fetchFromGitHub, kernel, kmod, linuxHeaders, ... }:

stdenv.mkDerivation rec {
  name = "corsair-pro-led-${version}-${kernel.version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "travisdavis-ops";
    repo = "corsair-pro-led.module";
    rev = "cbeb9f932948ea09320ee099adce540ced8b896d";

    sha256 = "sha256-pOge5BWqJ6MeBor3xEbIPHuRBZcE/AjI0HBNhDQ6KjI=";

  };

  hardeningDisable = [ ]; # 1
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ linuxHeaders ]; # 2
  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "SRC=$(src)"
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  meta = with lib; {
    description = "A kernel module for managing led/fans connected to a Corsair Pro";
    homepage = "https://github.com/travisdavis-ops/corsair-pro-led.module";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

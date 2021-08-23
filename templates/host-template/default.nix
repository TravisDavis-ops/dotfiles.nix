{ pkgs, nur, builders, common, ... }:
let
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  name = "<HOSTNAME>";

  hardware = { };

  kernelPackages = pkgs.linuxPackages;

  initrdModules = [ ];

  kernelModules = [ ];

  kernelParams = [ ];

  bootLoader = { };

  network = { };

  wifi = { };

  userAccounts = [{
    name = "user";
    groups = [ "wheel" ];
    shell = pkgs.fish;
  }
    {
      name = "mgnt";
      groups = [ "wheel" ];
      shell = pkgs.fish;
    }];

  config = { };

  cpuCores = 0;
}

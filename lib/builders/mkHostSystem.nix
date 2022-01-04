{ system, home-manager, nur, lib, mkHostModules,... }:
hostConfig:
let
  module = mkHostModules hostConfig;
in lib.nixosSystem {
  inherit system;
  modules = [
    module.host

    home-manager.nixosModules.home-manager # lood the module

    # configure the options
    {
      home-manager = {
        extraSpecialArgs = { inherit nur; };
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ ../../modules/user ];
        users = module.profiles;
      };
    }
  ];
}

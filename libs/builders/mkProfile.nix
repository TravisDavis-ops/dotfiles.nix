{ nix, home-manager, lib, system, ... }:
with builtins;
{ userConfig, username, packages }:
home-manager.lib.homeManagerConfiguration {
  inherit system username;
  pkgs = nix;
  stateVersion = "21.05";
  configuration =
    let
      trySettings = tryEval (fromJSON (readFile /etc/hmsystemdata.json));
      machineData = if trySettings.success then trySettings.value else { };
      machineModule = { pkgs, config, lib, ... }: {
        options.machineData = lib.mkOption {
          default = { };
          description = "Settings passed from nixos system configuration.";
        };
        config.machineData = machineData;
      };
    in
    {
      imports = [ ../../modules/users machineModule ];
      local = userConfig;
      nixpkgs = {
        #overlays = overlays;
        config.allowUnfree = true;
      };
      systemd.user.startServices = true;

      home = {
        inherit packages username;
        homeDirectory = toPath "/home/${username}";
        stateVersion = "21.05";
      };
    };

  homeDirectory = "/home/${username}";
}


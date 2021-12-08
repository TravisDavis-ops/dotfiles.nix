{ system, nix, home-manager, lib, ... }: with builtins; rec {
    Script2App = { scriptPath }:{
        type = "app";
        program = toPath scriptPath;
    };

}

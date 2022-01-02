{ pkgs, lib, system, ... }@inputs:
let callPackage = lib.callPackageWith pkgs;
in
{
  nhentai = callPackage ./nhentai { pythonPackages = pkgs.python3Packages; };
  mangodl = callPackage ./mangodl { };
  xxh = callPackage ./xxh { pythonPackages = pkgs.python39Packages; };
  cocogitto = callPackage ./cocogitto { };
  swayhide = callPackage ./swayhide { };
  swaync = callPackage ./swaync { };
  nwg-dock = callPackage ./nwg-dock { };
  one-step-from-eden = (import ./one-step-from-eden { inherit lib; }) pkgs;
  cultist-simulator = (import ./cultist-simulator { inherit lib; }) pkgs;
  kentucky-route-zero = (import ./kentucky-route-zero { inherit lib; }) pkgs;
  legend-of-grimrock = (import ./legend-of-grimrock { inherit lib; }) pkgs;
  megaquarium = (import ./megaquarium { inherit lib; }) pkgs;
  moonlighter = (import ./moonlighter { inherit lib; }) pkgs;
  orwell = (import ./orwell { inherit lib; }) pkgs;
  orwell-iis = (import ./orwell-iis { inherit lib; }) pkgs;
  outlast = (import ./outlast { inherit lib; }) pkgs;
  shenzhen-io = (import ./shenzhen-io { inherit lib; }) pkgs;
  slay-the-spire = (import ./slay-the-spire { inherit lib; }) pkgs;
  slime-rancher = (import ./slime-rancher { inherit lib; }) pkgs;
  stardew-valley = (import ./stardew-valley { inherit lib; }) pkgs;
  torchlight = (import ./torchlight { inherit lib; }) pkgs;
}


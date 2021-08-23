{ system, nixpkgs, home-manager, nur, ... }@inputs: rec {

  callPackageWith = set: f: overrides: import f (set // overrides);

  callProfile = host: name: ({ ${name} = import ../hosts/${host}/profiles/${name}.nix; });

  reduce = with nixpkgs.lib; (f: list: (foldl f (head list) (tail list)));
  reduceToAttr = reduce (cs: c: c // cs);
  builders = callPackageWith inputs ./builders { inherit reduceToAttr callPackageWith callProfile builders; };
}

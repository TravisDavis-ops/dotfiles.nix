{ nix, nur, builders }:
let self = { 
	tod = import ./tod.nix { inherit builders nix nur; }; 
	cli = import ./cli.nix { inherit builders nix nur; };
};
in self

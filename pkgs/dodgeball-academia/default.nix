{ builders, ... }@inputs:
let b =
  builders.mkWin64Game rec {
    pname = "dodgeball-academia";
    iname = "dodgeball_academia";
    ename = "DodgeballAcademia";
    version = "1.5_64bit_49555";
    sha256 = "1sl7iq9y666msy3znrphmj8r41psy7j7nw5nrhilqi4n4hib6qmz";
  }; in b (inputs)

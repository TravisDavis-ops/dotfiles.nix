source $stdenv/setup

buildPhase(){
    echo "Build";
}

installPhase(){
    echo "Install";
    ls $out;
}



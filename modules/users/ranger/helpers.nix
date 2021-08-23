{
  mkFileRule = { extension, command, args ? [ "$@" ] }: ''
    ext ${extension} = ${command} ${toString args}
  '';
}

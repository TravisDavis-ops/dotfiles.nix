{
  mkSwayOutput = { name, mode, position }: ''
    output ${name} {
      mode ${mode}
      pos ${toString position}
    }
  '';
  mkSwayExec = { program, always ? false, args ? [ ] }:
    if always then ''
      exec_always ${program} ${toString args}
    '' else ''
      exec ${program} ${toString args}
    '';
  mkSwayKeybinding = { combo, action }: ''
    bindsym ${combo} ${action}
  '';
  mkSwayVariable = { name, value }: ''
    set ${name} ${value}
  '';
  mkSwaySetting = { key, value }: ''
    ${key} ${value}
  '';
  mkSwayWorkspace = { name, output }: ''
    workspace ${name} output ${output}
  '';
}

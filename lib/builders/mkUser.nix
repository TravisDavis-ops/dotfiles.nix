{ name, groups, shell, password, ... }: {
  users.users."${name}" = {
    inherit name shell;
    isNormalUser = true;
    extraGroups = groups;
    initialPassword = password;
  };
}

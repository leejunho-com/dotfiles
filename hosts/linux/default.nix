{ user, ... }:

{
  system.stateVersion = "25.11";

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
  };
}

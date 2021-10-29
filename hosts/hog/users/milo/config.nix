{ pkgs, user, ... }:

{
  shell = pkgs.zsh;
  home = "/home/milo";
  description = "Milo Gertjejansen";
  createHome = true;
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" ];

  openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDH0pxY8XS64hJF8Z/LWh8ZWfdo1uz+ivU7pXsGcTgxL+NtQIGK4aE0+lnLVj9/L96U1cSH/G7/dGYESFBc13P6rD+ggp/JFKof9qKdhsgdtdN8ExdaDWEG91PAYmxaL8iZlFXuHWNpZH9khgZxbuZXgPfviQqz30b4HQgZJraRY8Ds1BjmZZ3Kn3A5Z9fEbtyqJKRs8r42cXnHU9zMwm022L4B4S4bwmlLGdFXT9aZ+r374eAKvLZKWfIYJXq1eNXSWjKRZySLfTypE1oiwzBDtGCUb2cZA+l735S1wIgQK5oV2Wpd7RixkYQVAYJ2lHecl/tAdb7HlErgOrvzf6wP cardno:000611506311"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjqvS7FDdRvKHj/3qTKjTvox/zVsGZoL/LYXQ47nT7Z JuiceSSH"
  ];
}

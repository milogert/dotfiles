{ pkgs, ... }:

rec {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
<<<<<<< HEAD
    ../_common/default-headless.nix
=======
    ../_common/default.nix
>>>>>>> 92998cc (Add rig)
    ./networking.nix
    ./services.nix
    #../_common/services.nix
  ];

<<<<<<< HEAD
=======
  programs.sway.enable = true;

  # TODO: This should belong in the rest of the user config.

>>>>>>> 92998cc (Add rig)
  # This is required here for nix-darwin.
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "exa -l -g --git --color always --icons -a -s type";
      ls = "exa --color auto --icons -a -s type";
    };
  };

<<<<<<< HEAD
=======
  programs.steam.enable = true;

>>>>>>> 92998cc (Add rig)
  environment.variables = {
    HOSTNAME = "rig";
  };
  environment.systemPackages = with pkgs; [
    ranger
  ];
}

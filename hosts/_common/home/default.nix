{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git
    ./lazydocker.nix
    /* ./neovim */
    ./password-store.nix
    ./starship.nix
    ./tmux
    ./xdg.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    deadnix
    neofetch
  ];
}

{ pkgs, ... }:

rec {
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./browserpass.nix
    ./fzf.nix
    ./git
    ./neovim
    ./password-store.nix
    ./starship.nix
    ./tmux
    ./zsh
  ];

  home.packages = with pkgs; [
    imlib2
    neofetch
    w3m
  ];
}

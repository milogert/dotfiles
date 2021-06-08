{ pkgs, ... }:

rec {
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./browserpass.nix
    ./fzf.nix
    ./git
    ./neovim
    ./starship.nix
    ./tmux
    ./zsh
  ];
}

{ pkgs, ... }:

rec {
  imports = [
    ./git
    ./neovim
    ./zsh
    ./browserpass.nix
    ./fzf.nix
    ./starship.nix
    ./bat.nix
    ./tmux.nix
    ./alacritty.nix
  ];
}

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
}

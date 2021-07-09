{ pkgs, ... }:

rec {
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git
    ./neovim
    ./password-store.nix
    ./starship.nix
    ./tmux
    ./zsh
  ];
}

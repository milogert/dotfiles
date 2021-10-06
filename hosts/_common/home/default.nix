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
    ./ranger.nix
    ./starship.nix
    ./tmux
    ./zsh
  ];

  home.packages = with pkgs; [
    neofetch
  ];
}

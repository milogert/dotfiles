{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git
    ./neovim
    ./password-store.nix
    ./starship.nix
    ./tmux
    ./xdg.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    neofetch
  ];
}

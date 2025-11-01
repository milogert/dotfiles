{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git.nix
    ./lazydocker.nix
    ./neovim.nix
    ./password-store.nix
    ./starship.nix
    ./tmux
    ./xdg.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    deadnix
    neofetch
    slumber
  ];
}

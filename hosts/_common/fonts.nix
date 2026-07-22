{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira-code
    hack-font
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];
}

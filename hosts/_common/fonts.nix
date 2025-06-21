{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira-code
    hack-font
    iosevka
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
  ];
}

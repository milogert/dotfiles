{ config
, pkgs
, ...
}:

{
  imports = [
    ./sway.nix
    ./waybar
    ./desktop.nix
    # ./hyprland.nix
  ];

  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    calibre
    cargo
    warpinator
    cockatrice
    cryptsetup
    discord
    evince
    firefox
    gamescope
    mangohud
    neomutt
    phoronix-test-suite
    pinentry-curses
    ranger
    vassal
    vial
    vulkan-tools
  ];

  programs.qutebrowser = {
    enable = true;

    extraConfig = ''
    '';

    keyBindings = {
      normal = {
        "<Ctrl-v>" = "spawn mpv {url}";
        ",p" = "spawn --userscript qute-pass";
        ",l" = ''config-cycle spellcheck.languages ["en-GB"] ["en-US"]'';
      };
      prompt = {
        "<Ctrl-y>" = "prompt-yes";
      };
    };

    keyMappings = {};

    quickmarks = {
      nixpkgs = "https://github.com/NixOS/nixpkgs";
      home-manager = "https://github.com/nix-community/home-manager";
    };

    settings = {
      colors = {
        hints = {
          bg = "#000000";
          fg = "#ffffff";
        };
        tabs.bar.bg = "#000000";
      };
      qt.highdpi = true;
    };
  };
}

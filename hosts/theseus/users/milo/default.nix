{ config
, pkgs
, ...
}:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./desktop.nix
  ];

  home.stateVersion = "21.05";

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd;

    settings.global = {
      username = "milo@milogert.com";
      password_cmd = "jq -r \".spotifyd.password\" /etc/nixos/secrets.nix"; 
      device_name = "theseus";
    };
  };

  home.packages = with pkgs; [
    calibre
    cargo
    cider
    cinnamon.warpinator
    cockatrice
    cryptsetup
    discord
    elixir
    evince
    firefox
    insomnia
    libsForQt5.kdeconnect-kde
    mangohud
    mutt
    nodejs
    phoronix-test-suite
    pinentry-curses
    ranger
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

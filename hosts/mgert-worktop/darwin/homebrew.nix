{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "homebrew/cask-versions"
    ];

    brews = [
      "ios-deploy"
      "pinentry-mac"
    ];

    casks = [
      "1password"
      "beekeeper-studio"
      "calibre"
      "cyberduck"
      # "docker" # Docker Desktop is not supported in homebrew currently.
      "flipper"
      "google-chrome"
      "insomnia"
      "muzzle"
      "moom"
      "notion"
      "openvpn-connect"
      "plex"
      "pocket-casts"
      "postgres-unofficial"
      "slack"
      "vial"
      "vyprvpn"
      "zight"
      "zoom"
    ];

    masApps = {
      "1Blocker" = 1365531024;
      "Amazon Kindle" = 302584613;
      ColorSlurp = 1287239339;
      "Next Meeting" = 1017470484;
      Tailscale = 1475387142;
      Xcode = 497799835;
    };

    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}

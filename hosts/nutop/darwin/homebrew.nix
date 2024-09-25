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
      "MonitorControl"
      "calibre"
      "cyberduck"
      "docker"
      "google-chrome"
      "logi-options-plus"
      "moom"
      "muzzle"
      "plex"
      "pocket-casts"
      "postgres-unofficial"
      "slack"
      "vial"
      "yubico-yubikey-manager"
    ];

    masApps = {
      "1Blocker" = 1365531024;
      "Amazon Kindle" = 302584613;
      "Next Meeting" = 1017470484;
      ColorSlurp = 1287239339;
      Numbers = 409203825;
      Pages = 409201541;
      Xcode = 497799835;
    };

    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}

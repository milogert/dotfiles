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
      "beekeeper-studio"
      "calibre"
      "discord"
      "docker"
      "flipper"
      "google-chrome"
      "insomnia"
      "notion"
      "plex"
      "pocket-casts"
      "postgres-unofficial"
      "vial"
      "yubico-yubikey-manager"
    ];

    masApps = {
      "1Blocker" = 1365531024;
      "Amazon Kindle" = 302584613;
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

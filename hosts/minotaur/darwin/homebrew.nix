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
      "arc"
      "calibre"
      "cyberduck"
      "discord"
      "flipper"
      "google-chrome"
      "insomnia"
      "moom"
      "notion"
      "plex"
      "pocket-casts"
      "postgres-unofficial"
      "vial"
    ];

    masApps = {
      "1Blocker" = 1365531024;
      "Amazon Kindle" = 302584613;
      ColorSlurp = 1287239339;
      "Next Meeting" = 1017470484;
      Xcode = 497799835;
    };

    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}

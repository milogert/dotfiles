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
      "google-chrome"
      "insomnia"
      "logi-options-plus"
      "muzzle"
      "moom"
      "plex"
      "pocket-casts"
      "postgres-unofficial"
      "slack"
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

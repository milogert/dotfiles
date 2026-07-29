{
  taps = [
    # "homebrew/cask-versions"
    # This isn't working
    "PeonPing/tap"
  ];

  brews = [
    "PeonPing/tap/peon-ping"
    "ios-deploy"
    { name = "pinentry-mac"; trusted = true; }
  ];

  casks = [
    "calibre"
    "google-chrome"
    "moom"
    "obsidian"
    "plex"
    "postgres-app"
    "session-manager-plugin"
    "vial"
    "yubico-authenticator"
  ];

  masApps = {
    "1Blocker" = 1365531024;
    "Amazon Kindle" = 302584613;
    "Next Meeting" = 1017470484;
    "Numbers: Make Spreadsheets" = 361304891;
    "Pages: Create Documents" = 361309726;
    "Unwatched for YouTube" = 6477287463;
    ColorSlurp = 1287239339;
    Xcode = 497799835;
  };

  extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}

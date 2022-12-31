{ config, pkgs, ... }:

{
  programs.alacritty.settings.window.decorations = "buttonless";
  programs.alacritty.settings.font.size = 11.0;

  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in config.lib.dag.entryAfter [ "writeBoundary" ] ''
      #set -x
      baseDir="$HOME/Applications/Home Manager"
      if [ -d "$baseDir" ]; then
        rm -rf "$baseDir"
      fi
      mkdir -p "$baseDir"
      for appFile in ${apps}/Applications/*.app; do
        appName=$(basename "$appFile")
        target="$baseDir/$appName"

        # This way copies and makes it available in Spotlight.
        echo "  Copying $appName"
        echo "    from $appFile"
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
        $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"

        # This way symlinks, but makes it not available in Spotlight.
        #$DRY_RUN_CMD ln ''${VERBOSE_ARG:+-v} -s "$appFile" "$target"
      done
      #set +x
    '';
  };
}

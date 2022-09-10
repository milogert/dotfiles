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
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
        $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"

        # This way symlinks, but makes it not available in Spotlight.
        #$DRY_RUN_CMD ln ''${VERBOSE_ARG:+-v} -s "$appFile" "$target"
      done
      #set +x
    '';
  };
  /* home.activation = { */
  /*   aliasApplications = config.lib.dag.entryAfter [ "writeBoundary" ] '' */
  /*     app_path=$HOME/Applications/Home\ Manager */
  /*     apps_fixed=(${config.home.path}/Applications/*.app) */
  /*     echo HOME PATH ${config.home.path} */

  /*     $DRY_RUN_CMD rm -rf "$app_path" */
  /*     $DRY_RUN_CMD mkdir -p "$app_path" */
  /*     #for app in "''${apps_fixed[@]}"; do */
  /*     for app in ${config.home.path}/Applications/*.app; do */
  /*       echo APP NAME "$app" */
  /*       $DRY_RUN_CMD rm -f "$app_path"/"$(basename $app)" */
  /*       target="$app_path"/"$(basename $app)" */
  /*       echo LINK TARGET "$target" */
  /*       $DRY_RUN_CMD ln -s "$app" "$app_path" */
  /*       #$DRY_RUN_CMD osascript \ */
  /*       #  -e "tell app \"Finder\"" \ */
  /*       #  -e "make new alias file at POSIX file \"$app_path\" to POSIX file \"$app\"" \ */
  /*       #  -e "set name of result to \"$(basename $app)\"" \ */
  /*       #  -e "end tell" */
  /*       #$DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$app" "$app_path" */
  /*       #$DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target" */
  /*     done */
  /*   ''; */
  /* }; */
}

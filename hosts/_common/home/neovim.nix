{
  config,
  lib,
  pkgs,
  ...
}:

let
  octoPath = "${config.xdg.configHome}/nvim/snippets/octo.json";
in
{
  home.packages = with pkgs; [ lazydocker ];

  home.file."${config.xdg.configHome}/nvim/snippets/package.json".text = lib.generators.toJSON { } {
    name = "personal-snippets";
    contributes = {
      snippets = [
        {
          language = [
            "octo"
          ];
          path = octoPath;
        }
      ];
    };
  };

  home.file."${octoPath}".text = lib.generators.toJSON { } {
    "conventional comment" = {
      prefix = "cc";
      body = [
        "**\${1:type}(\${2:scope})**: \${3:title}"
        ""
        "$0"
      ];
    };
  };
}

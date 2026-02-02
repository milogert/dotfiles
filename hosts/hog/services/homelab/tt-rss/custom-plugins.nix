{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

{
  tt-rss-plugin-feediron = stdenv.mkDerivation rec {
    pname = "ttrss_plugin-feediron";
    # version = "v1.33";
    version = "5573ffde9c2c782eae1616e86127fb27e150130a";

    src = fetchFromGitHub {
      owner = "feediron";
      repo = pname;
      rev = version;
      sha256 = "1c737i390fc1wwdw1jh2bab92pmzlmyh75wnmnxldvaajd01fki9";
    };

    installPhase = ''
      mkdir -p $out/feediron

      cp -R bin $out/feediron/bin
      cp -R filters $out/feediron/filters
      cp -R preftab $out/feediron/preftab
      cp -R recipes $out/feediron/recipes
      cp init.php $out/feediron/init.php
    '';

    meta = with lib; {
      description = "Evolution of ttrss_plugin-af_feedmod";
      longDescription = ''
        This is a plugin for Tiny Tiny RSS (tt-rss).
        It allows you to replace an article's contents by the contents of an element on the linked URL's page

        i.e. create a "full feed".
      '';
      license = licenses.mit;
      homepage = "https://github.com/feediron/ttrss_plugin-feediron";
      maintainers = with maintainers; [ milogert ];
      platforms = platforms.all;
    };
  };
}

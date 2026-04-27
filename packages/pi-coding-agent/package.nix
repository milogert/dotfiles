{
  lib,
  buildNpmPackage,
  fetchurl,
  importNpmLock,
  nodejs_20,
}:

buildNpmPackage rec {
  pname = "pi-coding-agent";
  version = "0.70.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha256-bv+JqGQb0tIUXkm4B7f874y9VUzxlP/DHRq+DjYGddU=";
  };

  npmDeps = importNpmLock {
    package = lib.importJSON ./package.json;
    packageLock = lib.importJSON ./package-lock.json;
  };
  inherit (importNpmLock) npmConfigHook;

  nodejs = nodejs_20;
  dontNpmBuild = true;

  meta = {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent";
    license = lib.licenses.mit;
    mainProgram = "pi";
    platforms = lib.platforms.unix;
  };
}

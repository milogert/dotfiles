{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
}:

buildNpmPackage rec {
  pname = "obsidian-livesync-cli";
  version = "1.0.21-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "vrtmrz";
    repo = "obsidian-livesync";
    rev = "415f81d53352e66f74091b6ed2e2d1d38ff709b9";
    hash = "sha256-jj15HADmLJegrhF/qo76cBGeRKuwMRzjfyC9JVqkrjU=";
  };

  npmDepsHash = "sha256-+q5SkzE9tJHYAkBFeVrgg7qUh4spKgCaGDuJIqTMLuk=";

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    npm run build -w self-hosted-livesync-cli
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/obsidian-livesync-cli $out/bin
    cp -R src/apps/cli/dist $out/lib/obsidian-livesync-cli/dist
    cp -R node_modules $out/lib/obsidian-livesync-cli/node_modules
    rm -f \
      $out/lib/obsidian-livesync-cli/node_modules/self-hosted-livesync-cli \
      $out/lib/obsidian-livesync-cli/node_modules/livesync-webapp \
      $out/lib/obsidian-livesync-cli/node_modules/webpeer

    makeWrapper ${lib.getExe nodejs} $out/bin/livesync-cli \
      --add-flags "$out/lib/obsidian-livesync-cli/dist/index.cjs"

    runHook postInstall
  '';

  meta = {
    description = "Command-line Self-hosted LiveSync client for Obsidian vaults";
    homepage = "https://github.com/vrtmrz/obsidian-livesync/tree/main/src/apps/cli";
    license = lib.licenses.mit;
    mainProgram = "livesync-cli";
  };
}

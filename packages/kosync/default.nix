{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  lua51Packages,
  openresty,
  makeWrapper,
}:

let
  luaEnv = lua51Packages.lua.withPackages (ps: with ps; [
    ansicolors
    busted
    lua-cjson
    luadbi
    luafilesystem
    luaposix
    luasec
    luasocket
    penlight
  ]);

  koreaderSyncServer = fetchFromGitHub {
    owner = "koreader";
    repo = "koreader-sync-server";
    rev = "597e0648be0894c535a222f192d7bd583fb3b2dc";
    sha256 = "0p2d6ym1122y0cn396rcnj2plbmz73mkw88x8i1q1phqwfqfl5g4";
  };

  gin = fetchFromGitHub {
    owner = "ostinelli";
    repo = "gin";
    rev = "cb35e87fa0671fcf25e5bce5cb9487dee8b497e2";
    sha256 = "1lw96cr2w2l2d99i56j7dq2vz1yajlqsavlh99g9zszib6rnljqx";
  };

  luaRestyRedis = fetchFromGitHub {
    owner = "openresty";
    repo = "lua-resty-redis";
    rev = "4fe24e795dc5b70737127fac3e163bd4eb5cd268";
    sha256 = "1mm3j6shns1wzzg1lj9zh77grp4sn54gr5yihc7kbb7msiil76mm";
  };

in
stdenvNoCC.mkDerivation {
  pname = "kosync";
  version = "unstable-2025-09-14";

  src = koreaderSyncServer;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kosync $out/share/lua/5.1 $out/share/lua-resty-redis $out/bin

    cp -R . $out/share/kosync/

    cp -R ${gin}/gin $out/share/lua/5.1/gin
    cp ${gin}/bin/gin $out/bin/gin
    chmod -R u+w $out/share/lua/5.1/gin
    patch -d $out/share/lua/5.1 -p1 < $out/share/kosync/gin.patch

    cp -R ${luaRestyRedis}/lib $out/share/lua-resty-redis/lib

    makeWrapper ${luaEnv}/bin/lua $out/bin/kosync \
      --prefix PATH : ${lib.makeBinPath [ luaEnv openresty ]}:${openresty}/nginx/sbin \
      --set LUA_PATH "$out/share/lua/5.1/?.lua;$out/share/lua/5.1/?/init.lua;$out/share/lua-resty-redis/lib/?.lua;$out/share/lua-resty-redis/lib/?/init.lua;${luaEnv}/share/lua/5.1/?.lua;${luaEnv}/share/lua/5.1/?/init.lua;;" \
      --set LUA_CPATH "${luaEnv}/lib/lua/5.1/?.so;;" \
      --set LUA_PACKAGE_PATH "$out/share/lua/5.1/?.lua;$out/share/lua/5.1/?/init.lua;$out/share/lua-resty-redis/lib/?.lua;$out/share/lua-resty-redis/lib/?/init.lua;${luaEnv}/share/lua/5.1/?.lua;${luaEnv}/share/lua/5.1/?/init.lua;;" \
      --add-flags $out/bin/gin \
      --add-flags start \
      --add-flags --trace

    runHook postInstall
  '';

  meta = {
    description = "KOReader sync server packaged for native systemd/OpenResty use";
    homepage = "https://github.com/koreader/koreader-sync-server";
    license = lib.licenses.agpl3Only;
  };
}

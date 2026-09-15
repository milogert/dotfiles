let
  userHogMilo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBd16tgf4w3UYvAemneiqbbdzLS+lE2n2kU9Nkv4Wgys milo@hog";
  users = [ userHogMilo ];

  hog = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSdpbmMIGT1pdNiC3G1Ha4zPDyHQJMtLwf0/NnIItty root@nixos";
  theseus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlm3elIZpaMhWqVFOFJKmvdu/COrRgUP7S9J4EroaYP root@theseus";
  systems = [
    hog
    theseus
  ];

  all = users ++ systems;
in
{
  # Personal
  "secrets/milo/pi/HERMES_PROXY_API_KEY.age".publicKeys = users;

  # Hermes Agent
  "secrets/hermes-agent/DISCORD_BOT_TOKEN.age".publicKeys = all;
  "secrets/hermes-agent/API_SERVER_KEY.age".publicKeys = all;
  "secrets/hermes-agent/DASHBOARD_AUTH_USERNAME.age".publicKeys = all;
  "secrets/hermes-agent/DASHBOARD_AUTH_PASSWORD.age".publicKeys = all;
  "secrets/hermes-agent/HERMES_DASHBOARD_OAUTH_CLIENT_ID.age".publicKeys = all;

  # Hosting
  "secrets/ROUTE53_API_KEY.age".publicKeys = all;

  # WireGuard
  "secrets/wireguard/hog-private.age".publicKeys = all;

  # Obsidian
  "secrets/obsidian/COUCH_DB.age".publicKeys = all;

  # Homer
  "secrets/homer/SONARR_API_KEY.age".publicKeys = all;
  "secrets/homer/RADARR_API_KEY.age".publicKeys = all;
  "secrets/homer/READARR_API_KEY.age".publicKeys = all;
  "secrets/homer/PROWLARR_API_KEY.age".publicKeys = all;
  "secrets/homer/PLEX_TOKEN.age".publicKeys = all;
  "secrets/homer/JELLYFIN_API_KEY.age".publicKeys = all;
}

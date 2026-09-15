#!/usr/bin/env bash

mkdir -p secrets/homer                                                                                                                                                                                                                 │
mkdir -p secrets/hermes-agent
mkdir -p secrets/milo/pi

nix run github:ryantm/agenix -- -e secrets/homer/JELLYFIN_API_KEY.age                                                                                                                                                               │
nix run github:ryantm/agenix -- -e secrets/homer/READARR_API_KEY.age                                                                                                                                                                │
nix run github:ryantm/agenix -- -e secrets/homer/PROWLARR_API_KEY.age                                                                                                                                                               │
nix run github:ryantm/agenix -- -e secrets/homer/RADARR_API_KEY.age                                                                                                                                                                 │
nix run github:ryantm/agenix -- -e secrets/homer/SONARR_API_KEY.age                                                                                                                                                                 │
nix run github:ryantm/agenix -- -e secrets/homer/PLEX_TOKEN.age                                                                                                                                                                     │
nix run github:ryantm/agenix -- -e secrets/hermes-agent/HERMES_DASHBOARD_OAUTH_CLIENT_ID.age                                                                                                                                        │
nix run github:ryantm/agenix -- -e secrets/hermes-agent/DASHBOARD_OAUTH.age
nix run github:ryantm/agenix -- -e secrets/milo/pi/HERMES_PROXY_API_KEY.age
nix run github:ryantm/agenix -- -e secrets/obsidian/COUCH_DB.age
nix run github:ryantm/agenix -- -e secrets/ROUTE53_API_KEY.age
nix run github:ryantm/agenix -- -e secrets/hermes-agent/DASHBOARD_AUTH_USERNAME.age
nix run github:ryantm/agenix -- -e secrets/hermes-agent/DASHBOARD_AUTH_PASSWORD.age
nix run github:ryantm/agenix -- -e secrets/hermes-agent/API_SERVER_KEY.age
nix run github:ryantm/agenix -- -e secrets/hermes-agent/DISCORD_BOT_TOKEN.age

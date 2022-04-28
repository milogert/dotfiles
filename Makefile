HOST=${HOSTNAME}

define usage
@echo "Usage:"
@echo "  config"
@echo "    Requires that HOSTNAME be set. Configures that machine."
@echo "  install_requirements"
@echo "    Installs any missing requirements, used on nix-darwin."
@echo "  update"
@echo "    Updates the flake.lock file so new versions can be installed."
@echo
@echo "Anything prefixed with '_' is internal, but can be run separately if you need granular output."
endef

all: config

usage: help
help:
	$(usage)

check:
ifeq (${HOST},)
	@echo -e "\033[0;31mCall make with \033[1;34mHOSTNAME=your_host make config\033[0;31m instead.\033[0m"
	exit 1
else
	@echo -e "\033[0;32mChecks passed for ${HOST}, proceeding with build and switch\033[0m"
endif

config: check ${HOST}
	@echo -e "\033[0;32mDone configuring ${HOST}\033[0m"
	@echo -e "\033[0;32m  Run \033[1;34mmake update && make config\033[0;32m if your programs are out of date\033[0m"

# NixOS commands.
_nixos-build:
	nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel"

_nixos-switch:
	sudo nixos-rebuild switch --flake ".#${HOST}"

# nix-darwin commands.
_nix-darwin-build:
	# Remove the flags here eventually. This is to bootstrap flakes on your
	# system. After these same flags should be inside the configuration files.
	nix build ".#darwinConfigurations.${HOST}.system" --experimental-features "nix-command flakes"

_nix-darwin-switch:
	./result/sw/bin/darwin-rebuild switch --flake ".#${HOST}"

install_requirements:
	@echo -e "\033[0;32mInstalling required programs\033[0m"
	./installers/homebrew
	./installers/nix

theseus: _nixos-build _nixos-switch

worktop: install_requirements _nix-darwin-build _nix-darwin-switch

rig: _nixos-build _nixos-switch

hog: _nixos-build _nixos-switch

update:
	nix flake update

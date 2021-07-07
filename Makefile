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
@echo "Anything prefixed with '_' is internal, but can be run separately if\nyou need granular output."
endef

all: help

help:
	$(usage)

check:
ifeq (${HOST},)
	@echo "\033[0;31mCall make with \033[1;34mHOSTNAME=your_host make config\033[0;31m instead.\033[0m"
	exit 1
else
	@echo "\033[0;32mChecks passed for ${HOST}, proceeding with build and switch\033[0m"
endif

config: check ${HOST}
	@echo "\033[0;32mDone configuring ${HOST}\033[0m"
	@echo "\033[0;32m  Run \033[1;34mmake update && make config\033[0;32m if your programs are out of date\033[0m"

install_requirements:
	./installers/homebrew
	./installers/nix

_theseus-build:
	nix build ".#nixosConfigurations.theseus.config.system.build.toplevel"

_theseus-switch:
	sudo nixos-rebuild switch --flake ".#theseus"

theseus: _theseus-build _theseus-switch

_worktop-build:
	nix build ".#darwinConfigurations.worktop.system" --experimental-features "nix-command flakes"

_worktop-switch:
	./result/sw/bin/darwin-rebuild switch --flake ".#worktop"

worktop: install_requirements _worktop-build _worktop-switch

_rig-build:
	nix build ".#nixosConfigurations.rig.config.system.build.toplevel"

_rig-switch:
	sudo nixos-rebuild switch --flake ".#rig"

rig: _rig-build _rig-switch

update:
	nix flake update

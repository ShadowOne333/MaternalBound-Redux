# Makefile for creating the 'Fixed PSI Animations' patch for the Base ROM
SHELL := /bin/bash

# Variables
START := $(shell date +%s)
CLEAN_ROM = EarthBound.sfc
BASE = PSIAnimsBase.sfc
CHECKSUM = d67a8ef36ef616bc39306aa1b486e1bd3047815a
PATCH_NAME = MaternalBound-Redux
PATCHED_ROM_NAME = Mother 2.sfc
PATCH_DIR = Patches
FLIPS = ./flips
TIME = `date +'%T, %a %d/%b/%Y'`
SHA1SUM = `sha1sum $(CLEAN_ROM) | awk '{ print $$1 }'`

# Targets
all: check_rom check_checksum create_base_rom compile_project create_patch create_both_patches finish

# Check if the base ROM exists and has the correct name
check_rom:
	@if [ ! -e $(CLEAN_ROM) ]; then \
		echo "ERROR: Base ROM not found."; \
		echo "Please, rename the ROM to '$(CLEAN_ROM)' to begin the patching process."; \
		exit 1; \
	fi
	@echo "ROM detected. Verifying name..."

# Verify SHA-1 checksum
check_checksum:
	@echo "Base ROM detected with proper name."; echo
	@echo "Verifying SHA-1 checksum hash..."
	@if [ "$(SHA1SUM)" != "$(CHECKSUM)" ]; then \
		echo "ERROR: Base ROM checksum is incorrect."; \
		echo "Use an EarthBound ROM with the proper SHA-1 checksum for patching."; \
		exit 1; \
	fi
	@echo "Base ROM SHA-1 checksum verified."; echo

# Create the base ROM if it doesn't exist
create_base_rom:
	@if [ ! -f $(BASE) ]; then \
		echo "Base ROM ($(BASE)) not found, creating it..."; \
		coilsnake-cli patchrom $(CLEAN_ROM) $(BASE) "Patches/FixedPSIAnims.ebp" false; echo; \
		coilsnake-cli expand $(BASE) false; echo; \
	else \
		echo "$(BASE) already exists, proceeding..."; echo; \
	fi

# Compile the full CoilSnake Project
compile_project:
	@echo "Starting compilation process..."; echo
	@coilsnake-cli compile Project/ $(BASE) "$(PATCHED_ROM_NAME)"

# Create the EBP patch based on the Project
create_patch:
	@echo
	@coilsnake-cli createpatch $(CLEAN_ROM) "$(PATCHED_ROM_NAME)" "$(PATCH_DIR)/$(PATCH_NAME).ebp" "ShadowOne333" "A new MaternalBound with New Controls, MSU-1 integration and much more!" "MaternalBound Redux"

# Create both additional BPS and IPS patches files
create_both_patches:
	@echo
	@echo "Creating both BPS and IPS patches..."
	@$(FLIPS) -c "$(CLEAN_ROM)" "$(PATCHED_ROM_NAME)" "$(PATCH_DIR)/$(PATCH_NAME).bps"
# IPS patches will no longer be made due to them not checking the base ROM for patching, causing glitches in wrong base ROMs
#	@$(FLIPS) -c "$(CLEAN_ROM)" "$(PATCHED_ROM_NAME)" "$(PATCH_DIR)/$(PATCH_NAME).ips"
#	@echo; echo "BPS & IPS patches created successfully!"; echo
	@echo; echo "BPS patch created successfully!"; echo

# Finish the process
finish:
	@echo "Final compilation time: $$(( `date +%s` - $(START) )) seconds"
	@echo "Redux compilation finished at $(TIME)!"

.PHONY: all check_rom check_checksum create_base_rom compile_project create_patch create_both_patches finish

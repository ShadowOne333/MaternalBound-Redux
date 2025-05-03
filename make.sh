#! /bin/bash
#-------------------------------------------------------------
# Create the 'Fixed PSI Animations' patch for the Base ROM
#coilsnake-cli createpatch "EarthBound.smc" "EarthBound (Expanded).smc" "FixedPSIAnims.ebp" ShadowOne333 "Clean up PSI Animations from garbage pixels/tiles" "PSI Animations Fixes" && \
#-------------------------------------------------------------
TIME=$(date +'%T, %a %d/%b/%Y')
SECS=$(date +%s)
CLEAN_ROM="EarthBound.smc"
BASE="PSIAnimsBase.smc"
CHECKSUM="e44b6a73359694c25dd4ecc768128d40ec9b6dd1"
#-------------------------------------------------------------
# Error message function
Error()
{
	echo; echo "Redux compilation exited with errors!"
	echo "ERROR: $error"
}
#-------------------------------------------------------------
# Script end function
End()
{	
	sleep 1
	exit
}
#-------------------------------------------------------------
# Check base ROM name to be "EarthBound.smc"
	if [ -e EarthBound.smc ]; then
		echo "ROM detected. Verifying name..."
	else
		export error="Incorrect ROM name."
		Error;
		echo "Please, rename the ROM to 'EarthBound.smc' to begin the patching process."
		End;
	fi
#-------------------------------------------------------------
# SHA-1 sum verification
	if [ -f "$CLEAN_ROM" ]; then
		echo; echo "Base ROM detected with proper name."
		echo "Verifying SHA-1 checksum hash..."
	else
		export error="Base ROM not found."
		Error;
		echo "Place the 'EarthBound.smc' ROM inside this directory."
		End;
	fi

	export	SHA1=$(sha1sum "$CLEAN_ROM" | awk '{ print $1 }')
#-------------------------------------------------------------
# SHA-1 sum verified, begin patching...
	if [ "$SHA1" == "$CHECKSUM" ]; then
		echo; echo "Base ROM SHA-1 checksum verified."
		echo "Starting patching process..."; echo;
	else
		export error="Base ROM checksum is incorrect."
		Error;
		echo "Use an EarthBound ROM with the proper SHA-1 checksum for patching."
		End;
	fi
#-------------------------------------------------------------
# Patch the Base ROM with the Expanded PSI Animations
	if [ -f $BASE ]; then
		echo "$BASE exists, proceeding with compilation..."
	else
		echo "Base ROM ($BASE) not found, creating it..."
		coilsnake-cli patchrom EarthBound.smc $BASE "Patches/FixedPSIAnims.ebp" headered
		coilsnake-cli expand $BASE exhi
	fi
#-------------------------------------------------------------
# Compile the full CoilSnake Project for MaternalBound Redux (--ccscriptoffset=F10000)
	echo && coilsnake-cli compile Project/ $BASE "Mother 2.smc" && \
#-------------------------------------------------------------
# Create the EBP patch based on the Project
	echo && coilsnake-cli createpatch EarthBound.smc "Mother 2.smc" "Patches/MaternalBound-Redux.ebp" "ShadowOne333" "A new MaternalBound with New Controls, MSU-1 integration and much more!" "MaternalBound Redux" && \
#-------------------------------------------------------------
# Create both additional BPS and IPS patches files (IPS removed for compatibility)
	echo && echo "Creating both BPS patch..." && \
	./flips -c EarthBound.smc "Mother 2.smc" "Patches/MaternalBound-Redux.bps" && \
	#./flips -c EarthBound.smc "Mother 2.smc" "Patches/MaternalBound-Redux.ips" && \
	echo "BPS patch created successfully!"
#-------------------------------------------------------------
# Finish script and jump to the "End" function
	echo; echo "Final compilation time: $(( $(date +%s) - SECS )) seconds"
	echo "Redux compilation finished at $TIME!"
	End;
#-------------------------------------------------------------

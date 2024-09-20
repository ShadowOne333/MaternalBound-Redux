#! /bin/bash

# Create the 'Fixed PSI Animations' patch for the Base ROM
#coilsnake-cli createpatch "EarthBound.smc" "EarthBound (Expanded).smc" "FixedPSIAnims.ebp" ShadowOne333 "Clean up PSI Animations from garbage pixels/tiles" "PSI Animations Fixes" && \

BASE="PSIAnimsBase.smc"

# Patch the Base ROM with the Expanded PSI Animations
if [ -f $BASE ]; then
	echo "$BASE exists, proceeding with compilation..."
else
	echo "Base ROM ($BASE) not found, creating it..."
	coilsnake-cli patchrom EarthBound.smc $BASE "Patches/FixedPSIAnims.ebp" headered
	coilsnake-cli expand $BASE exhi
fi

# Compile the full CoilSnake Project for MaternalBound Redux (--ccscriptoffset=F10000)
echo && coilsnake-cli compile Project/ $BASE "Mother 2.smc" && \

# Create the EBP patch based on the Project
echo && coilsnake-cli createpatch EarthBound.smc "Mother 2.smc" "Patches/MaternalBound-Redux.ebp" "ShadowOne333" "A new MaternalBound with New Controls, MSU-1 integration and much more!" "MaternalBound Redux" && \

# Create both additional BPS and IPS patches files (IPS removed for compatibility)
echo && echo "Creating both BPS patch..." && \
./flips -c EarthBound.smc "Mother 2.smc" "Patches/MaternalBound-Redux.bps" && \
#./flips -c EarthBound.smc "Mother 2.smc" "Patches/MaternalBound-Redux.ips" && \
echo "BPS patch created successfully!"

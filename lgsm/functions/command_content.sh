#!/bin/bash
# LinuxGSM command_content.sh function
# Author: Christian Birk
# Website: https://linuxgsm.com
# Description: Handles content downloading for Garry's Mod

commandname="CONTENT"
commandaction="Content"
functionselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"
#fn_firstcommand_set

contentfolder="${rootdir}/content"

# concept:
# check if folder exists
# check if any content is installed (subfolder with appid)

# install/update/remove content

# ID;Name
content=("232330;Counter Strike: Source" "232250;Team Fortress 2")

for contenttype in "${content[@]}";do
	echo "${contenttype}"
done

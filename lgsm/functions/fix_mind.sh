#!/bin/bash
# LinuxGSM fix_mind.sh function
# Author: Christian Birk
# Website: https://linuxgsm.com
# Description: Resolves startup issue with Mindustry

functionselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${serverfiles}:${serverfiles}/linux64"

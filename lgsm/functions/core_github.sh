#!/bin/bash
# LinuxGSM core_github.sh function
# Author: Christian Birk
# Website: https://linuxgsm.com
# Description: core function file for updates via github

local function_selfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

local github_api="https://api.github.com"

fn_github_local_version_file(){
	local github_release_user="${1}"
	local github_release_repo="${2}"

	github_local_version_file="${data}/github-${github_release_user}-${github_release_repo}-version"
}

# $1 githubuser/group
# $2 github repo name
fn_github_get_latest_release_version(){
	local github_release_user="${1}"
	local github_release_repo="${2}"

	github_latest_release_url="${github_api}/repos/${github_release_user}/${github_release_repo}/releases/latest"

	github_release_version=$(curl -s ${github_latest_release_url} | jq '.tag_name' )
}

# $1 githubuser/group
# $2 github repo name
fn_github_set_latest_release_version(){
	local github_release_user="${1}"
	local github_release_repo="${2}"

	fn_github_local_version_file "${github_release_user}" "${github_release_repo}"

	github_latest_release_url="${github_api}/repos/${github_release_user}/${github_release_repo}/releases/latest"
	github_release_version=$(curl -s ${github_latest_release_url} | jq -r '.tag_name' )

	echo "${github_release_version}" > "${github_local_version_file}"
}

# $1 githubuser/group
# $2 github repo name
# $3 set where to get the version file from
fn_github_get_installed_version(){
	local github_release_user="${1}"
	local github_release_repo="${2}"

	fn_github_local_version_file "${github_release_user}" "${github_release_repo}"

	github_local_version=$(cat "${github_local_version_file}")
}

fn_github_compare_version(){
	local github_release_user="${1}"
	local github_release_repo="${2}"
	local exitcode=0

	fn_github_local_version_file "${github_release_user}" "${github_release_repo}"
	github_latest_release_url="${github_api}/repos/${github_release_user}/${github_release_repo}/releases/latest"

	github_local_version=$(cat "${github_local_version_file}")
	github_release_version=$(curl -s ${github_latest_release_url} | jq '.tag_name' )

	if [ "${github_local_version}" == "${github_release_version}" ]; then
		echo "Remote and Local Version is the same , Version: ${local_version}"
	else
		# tbd check if version that is installed is higher than the remote version to not override it
		last_version=$(echo -e "${github_local_version}\n${github_release_version}" | sort -V | head -n1 )
		if [ "${github_local_version}" == "${github_release_version}" ]; then
			echo -e "Update from github repo available"
			echo -e "* Local version: ${green}${github_local_version}${default}"
			echo -e "* Remote version: ${green}${github_release_version}${default}"
			# if the version differs exit the function with a exit 1 to be able to check the return from the main script where it is used
			exit 1
		else
			# local version is higher than the remote version output this to the user
			# strange case but could be possible, as a release could be removed from github
			echo -e "Local version is newer than the remote version"
			echo -e "* Local version: ${green}${github_local_version}${default}"
			echo -e "* Remote version: ${green}${github_release_version}${default}"
		fi
	fi
}

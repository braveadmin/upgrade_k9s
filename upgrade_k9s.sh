#!/bin/bash

# run as sudo (necessary to copy the binary to /usr/local/bin)

# The script downloads the latest version, uncompresses the binary and sets to the binaries folder.
# If the installed version is the same as before the installation it considers that there wasn't 
# upgrades.

k9s_url="https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz"
k9s_package="k9s_Linux_amd64.tar.gz"
k9s_current_version="$(k9s version --short | grep Version | awk '{ print $2}')"

downloadK9sLatest(){
	wget "$k9s_url"
	installK9s
}

installK9s() {
	if [ -f "$k9s_package" ]; then
		tar -zxf "$k9s_package" k9s
		mv k9s /usr/local/bin/k9s || exit 1
		k9s_installed_version="$(k9s version --short | grep Version | awk '{ print $2}')"
		# Check that new version is different from the old one
		if [ "$k9s_current_version" != "$k9s_installed_version" ]; then
			echo "k9s successfully upgraded to version $k9s_installed_version"
			# Clean temp files
			rm "$k9s_package"
		else
			echo "k9s already in latest version ($k9s_current_version)"
			# Clean temp files
			rm "$k9s_package"
		fi
	else
		echo "Package $k9s_package doesn\'t exist. It seems that there was an issue while downloading the file." && exit 1
	fi
}

downloadK9sLatest

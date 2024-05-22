#!/bin/bash

# ---------- FUNCTIONS ---------- #

display_help() {
	echo
	echo "Usage: $(basename "$0") [options] [argument]"
	echo
	echo "Required:"
	echo "	username"
	echo "	SSH-link"
	echo
	echo "Arguments:"
	echo "	-u username		Username for the SSH-connection"
	echo "	-l SSH-link		Link to connect to the SSH- Server"
	echo "	-ppk ppk-File		The .ppk- file, only works with -new, not compatible with -unix"
	echo "	-pem pem-File		The .pem- file, not compatible with -unix"
	echo "	-unixkey UnixKey	The unix key path, by default set to ~/.ssh/id_rsa"
	echo "	-unix			For unix only connection, default is Windows- Unix combined"
	echo "	-k			If a key is needed, set this flag"
	echo
	echo "Options:"
	echo "	--help			Display this help message"
	echo "	--v/ --version		Display the version"
	echo "	-new			Initialize a new SSH-connection, is made for generating keys. If you don't need a key, you can ignore this"
	echo
	exit 0
}
display_version() {
	echo "$(basename "$0") on version 2.2.1"
	exit 0
}

# ---------- VARIABLES ---------- #

new=0
username="null"
link="null"
ppk="null"
pem="null"
unix=0
key=0

# ---------- ARGUMENT PROCESSING ---------- #

while [[ $# -gt 0 ]]; do
	case "$1" in
	--help)
        	display_help
            	;;
        --v | --version)
		display_version
		;;
	-new)
		new=1
		;;
	-u)
		shift
		username="$1"
		;;
	-l)
		shift
		link="$1"
		;;
	-ppk)
		shift
		ppk="$1"
		;;
	-pem)
		shift
		pem="$1"
		;;
	-k)
		key=1
		;;
	-unix)
		unix=1
		;;
	-unixkey)
		shift
		pem="$1"
		;;
	*)
		echo "Unknown argument!"
		exit 1
	esac
    shift
done

# ---------- PROGRAM ---------- #

if [ "$link" = "null" -o "$username" = "null" ]; then
	echo "Username and link required!"
	exit 1
fi

# Checking if openssh-client is already installed
# If not it installs itself
if ! dpkg -s openssh-client > /dev/null 2>&1; then
    sudo apt-get install openssh-client
fi

if [ "$key" -eq 0 ]; then
	ssh "$username"@"$link"
fi

if [ "$new" -eq 1 ]; then

	# Checking .ppk and .pem privateKey and if not available, get one
	if [ "$pem" = "null" -a "$unix" -eq 0 ]; then
		# Check for pem- file
		pem=$(find . -name "*.pem" -print -quit)
		if [ "$pem" = "null" ]; then
			if [ "$ppk" = "null" ]; then
				# Checking if the .ppk- file is in directory
				ppk=$(find . -name "*.ppk" -print -quit)
				if [ "$ppk" = "null" ]; then
					echo "Couldn't find a *.ppk- File"
					read -p "Please install putty from the official website, then continue" pass

					# Checking if wine is already installed
					# If not it install itself
					if ! dpkg -s wine > /dev/null 2>&1; then
       	    					sudo apt-get install wine
        				fi

					# Executing putty to generate keys
					wine putty.exe
					wine puttygen
					ppk=$(find . -name "*.ppk" -print -quit)
				fi
				# Asking about the file- name
				read -p "Under which name shall the new Key- File be stored?" i
				pem="$i.pem"
				
				# Checking if putty-tools is already installed
    				# If not it installs itself
    				if ! dpkg -s putty-tools > /dev/null 2>&1; then
        				sudo apt-get install putty-tools
    				fi

				# Creating a .pem- file from the existing .ppk- file
				puttygen "$ppk" -O private-openssh -o "$pem"
			fi
		fi
	elif [ "$unix" -eq 1 ]; then
		ssh-keygen
		read -p "Please enter path to SSH- key, including the key" pem
	fi

	chmod 600 "$pem"

else
	if [ "$unix" -eq 1 ]; then
		if [ "$pem"  = "null" ]; then
			pem=~/.ssh/id_rsa
		fi
	elif [ "$pem" = "null" ]; then
		pem=$(find . -name "*.pem" -print -quit)
		if [ "$pem" = "null" ]; then
			echo "Couldn't find the *.pem key- file"
			exit 1
		fi
	fi
fi

ssh -i "$pem" "$username"@"$link"

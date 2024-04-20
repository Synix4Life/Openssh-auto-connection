#!/bin/bash

display_help() {
	echo
	echo "Usage: $(basename "$0") [options] [argument]"
	echo
	echo "Arguments:"
	echo "  username            Username for the SSH- connection"
	echo
	echo "Options:"
	echo "  --help              Display this help message"
	echo "  --v/ --version      Display the version"
	echo
	exit 0
}
display_version() {
	echo "$(basename "$0") on version 1.0.2"
	exit 0
}

if [ "$#" -ne 1 ]; then
	echo -e "\nExpected one argument"
	echo -e "\nUsage: ./openssh.sh username!\n"
	exit 1
fi

if [ "$1" = "--help" ]; then
	display_help
elif [ "$1" = "--v" -o "$1" = "--version" ]; then
	display_version
fi

username=$1

echo "Already initalized the connection?[y/n]"

read already

if [ "$already" = "n" ]; then

	# Checking if openssh-client is already installed
	# If not it installs itself
	if ! dpkg -s openssh-client > /dev/null 2>&1; then
	    echo "openssh-client is not installed. Installing..."
	    sudo apt-get install openssh-client
	else
	    echo "openssh-client is already installed."
	fi

	# Question about privateKey
	echo "Do you already have a privateKey.ppk?[y/n]"
	read choice1
	if [ "choice1" = "n" ]; then
		echo "Please install putty from the official website, then continue"
		read pass0

		# Checking if wine is already installed
		# If not it install itself
		if ! dpkg -s wine > /dev/null 2>&1; then
            echo "wine is not installed. Installing..."
       	    sudo apt-get install wine
        fi

		# Executing putty to generate keys
		wine putty.exe
		wine puttygen
	fi

	# Checking if putty-tools is already installed
        # If not it installs itself
        if ! dpkg -s putty-tools > /dev/null 2>&1; then
            echo "putty-tools is not installed. Installing..."
            sudo apt-get install putty-tools
        else
            echo "putty-tools is already installed."
        fi

	# Checking if the .ppk- file is in directory
	# If not, exit with error
	ppkFile=$(find . -name "*.ppk" -print -quit)
	if [ -n "$ppkFile" ]; then
		echo "Couldn't find *.ppk- File"
		exit 1
	fi

	# Asking about the file- name
	echo "Under which name shall the new Key- File be stored?"
	read i
	key="$i.pem"

	# Creating a .pem- file from the existing .ppk- file
	puttygen "$ppkFile" -O private-openssh -o "$key"
	chmod 600 "$key"

else

	key=$(find . -name "*.pem" -print -quit)
	if [ -n "$java_file" ]; then
		echo "Couldn't find the *.pem key- file"
	else
		echo "key- file $key found, executing connection"
	fi

fi

# You have to add the signature to the SSH- Server!
# Remove the "___" and add tbe SSH- Server
ssh -i "$key" "$1"@___

#!/bin/bash

# RMIT:		CPT264, Assignment 2, Part B, Requirement 3
# Author:	Lance Bailey
# Version:	v1.0
# Description:	
#		- 
#
# Change Log:
#	v1.0	27/10/2019	Lance Bailey
#		Original version.
#


#--- VARIABLES ---

readonly FILENAME="find-script.sh"
readonly VERSION="1.0"

readonly FIND="/usr/bin/find"

find_action=""
find_depth=""
find_links=""
find_path=""
find_type=""

#--- FUNCTONS ---

print_help () {
	echo "Usage:"
	echo " $FILENAME [options]"
	echo ""
	echo "Options:"
	echo " -h, --help"	"Display this help and exit"
	echo " -v, --version"	"Display version information"
	echo ""
}

#--- SCRIPT START ---

# Get a valid path, if path is invalid then try again.
while [ -z $find_path ]
do
	read -p 'Enter a path [ENTER]: ' find_path
	if [ ! -d $find_path ]; then
		echo 'The path is invalid, please try again.'
		find_path=''
	fi
done

# Get what we are searching for: path, type, group or fstype.
while [ -z $find_type ]
do
	echo 'What would you like to find? Enter the first Letter:'
	read -p '[F]stype, [G]roup, [P]ath or [T]ype [ENTER]: ' find_type
	find_type=${find_type,,}
	if [[ ! $find_type =~ [fgpt] ]]; then
		echo 'Invalid option, please try again.'
		find_type=''
	fi
done

# Get the value of what is to be searched for.
while [ -z $find_value ]
do
	echo ''
done

# Get the maximum depth for this search.
while [ -z $find_depth ]
do
	echo''
done

# Symbolic links
while [ -z $find_links ]
do
	echo 'Do you want to follow symbolic links?'
	read -p '[Y]es or [N]o [ENTER] ' find_links
	find_links=${find_links,,}
	if [[ ! $find_link =~ [ny] ]]
		echo 'Invalid option, please try again.'
		find_links=''
	fi
done

# Get the action the to be performed on the search.
while [ -z $find_action ]
do
	echo 'What action would you like performed?'
	read -p '[C]ustom, [D]elete, [P]rint or Print[O] [ENTER]: ' find_action
	find_action=${find_action,,}
	if [[ ! $find_action =~ [cdpo] ]]; then
		echo 'Invalid option, please try again.'
		find_action=''
	fi
done


#--- END ---

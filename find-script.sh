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

readonly FILENAME='find-script.sh'
readonly VERSION='1.0'

readonly AWK='/usr/bin/awk'
readonly DF='/bin/df'
FIND='/usr/bin/find'

declare -a find_arguments=()
find_action=''
find_depth=''
find_links=''
find_path=''
find_pattern=''
find_test=''
find_test_subvalue=''
find_script=''


#--- FUNCTONS ---

print_invalid_option () {
	echo 'Invalid option, please try again.'
}

print_help () {
	echo 'Usage:'
	echo " $FILENAME [options]"
	echo ''
	echo 'Options:'
	echo ' -h, --help       Display this help and exit'
	echo ' -v, --version    Display version information'
	echo ''
}

#--- SCRIPT START ---

while getopts "hv" opt
do
	case ${opt} in
		h | \?)
			print_help
			exit
			;;
		v)
			echo "$FILENAME $VERSION"
			echo ''
			exit
			;;
	esac
done

# Get a valid path, if path is invalid then try again.
while [[ -z "$find_path" ]]
do
	read -r -p 'Enter a path : ' find_path
	if [[ ! -d $find_path ]]; then
		print_invalid_option
		find_path=''
	fi
done
find_arguments=("${find_arguments[@]} $find_path")

# Get what we are searching for: path, type, group or fstype.
# Along with the associated pattern.
while [[ -z "$find_test" ]]
do
	echo 'What would you like to find, enter the first letter: '
	read -r -p '[F]stype, [G]roup, [P]ath or [T]ype : ' find_test
	find_test=${find_test^^}
	
	# Check input is valid and then obtain more input for the pattern.
	if [[ ${#find_test} -ne 1  ]]; then
		print_invalid_option
		find_test=''
	# FStype.
	elif [[ "$find_test" == 'F' ]]; then
		find_test='-fstype'

		# Get valid file types on this system
		valid_fstypes=$($DF -T | $AWK '{if (NR!=1) {print $2}}' | sort -n | uniq | tr '\n' ' ')

		# Get file system type.
		while [[ -z "$find_test_subvalue" ]]
		do
			echo "Valid FS types on this system: $valid_fstypes (input not validated)"
			read -r -p 'Enter file system type : ' find_test_subvalue
		done	
		while [[ -z "$find_pattern" ]]
		do
			read -r -p 'Enter the pattern to search for : ' find_pattern
			find_pattern="-name \""$find_pattern"\""
		done

	# Group
	elif [[ "$find_test" == 'G' ]]; then
		find_test='-group'
		while [[ -z "$find_pattern" ]]
		do
			read -r -p 'Enter the group name : ' find_pattern
		done
	# Path
	elif [[ "$find_test" == 'P' ]]; then
		find_test='-path'
		while [[ -z "$find_pattern" ]]
		do
			read -r -p 'Enter the path/file name : ' find_pattern
			find_pattern="\""$find_pattern"\""
		done
	#Type
	elif [[ "$find_test" == 'T' ]]; then
		find_test='-type'

		# Get the test subvalue.
		while [[ -z "$find_test_subvalue" ]]
		do
			echo 'Enter the file type: '
			read -r -p '[B]lock, [C]haracter, [D]irectory, Named [P]ipe, Regular [F]ile, Symbolic [L]ink or [S]ocket : ' find_test_subvalue
			find_test_subvalue=${find_test_subvalue^^}

			# Check options are valid.
			if [[ ${#find_test_subvalue} -ne 1 ]]; then
				print_invalid_option
				find_test_subvalue=''
			elif [[ ! "$find_test_subvalue" =~ [BCDPFLS] ]]; then
				print_invalid_option
				find_test_subvalue=''
			else
				find_test_subvalue="${find_test_subvalue,,}"
			fi
		done
		while [[ -z $find_pattern ]]
		do
			read -r -p 'Enter pattern to search for : ' find_pattern
			find_pattern="-name \""$find_pattern"\""
		done
	else	
		print_invalid_option
		find_test=''
	fi
done
find_arguments=("${find_arguments[@]} $find_test")
if [[ ! -z "$find_test_subvalue" ]]; then
	find_arguments=("${find_arguments[@]} $find_test_subvalue")
fi
find_arguments=("${find_arguments[@]} $find_pattern")


# Get the maximum depth for this search, the should be a postive number including 0 or
# "" [ENTER] for unlimited.
while [[ -z "$find_depth" ]]
do
	echo 'How deep do you want the search to go?'
	read -r -p 'U = Unlimited, or enter a number (0+) : ' find_depth
	find_depth=${find_depth^^}
	
	if [[ "$find_depth" == 'U' ]]; then
		# Do not add find_depth to find_arguments as default depth is unlimited.
		find_depth='U'
	elif [[ $find_depth =~ ^[0-9]+$ ]]; then
		find_depth="-maxdepth $find_depth"
		find_arguments=("${find_arguments[@]} $find_depth")
	else
		print_invalid_option
		find_depth=''
	fi
done

# Symbolic links
while [[ -z "$find_links" ]]
do
	echo 'Do you want to follow symbolic links?'
	read -r -p '[Y]es or [N]o [ENTER]: ' find_links
	find_links=${find_links^^}

	if [[ $find_links == 'N' ]]; then
		find_links='-P'
	elif [[ $find_links == 'Y' ]]; then
		find_links='-L'
	else
		print_invalid_option
		find_links=''
	fi
done
find_arguments=("$find_links ${find_arguments[@]}")

# Get the action the to be performed on the search.
while [[ -z "$find_action" ]]
do
	echo 'What action would you like performed?'
	read -r -p '[C]ustom, [D]elete, [P]rint or Print[0] [ENTER]: ' find_action
	find_action=${find_action^^}
	
	if [[ ${#find_action} -ne 1 ]]; then
	       print_invalid option
	# Custom Script.
	elif [[ "$find_action" == 'C' ]]; then

		# Get the the script to run.
		while [[ -z "$find_script" ]]
		do
			read -r -p 'Enter script path and name : ' find_script
			if [[ ! -d "$find_script" ]]; then
				echo 'Script not found, please try again.'
				find_script=''
			fi
		done
		find_action="-exec $find_script"
	# Delete
	elif [[ "$find_action" == 'D' ]]; then
		find_action='-delete'
	# Print
	elif [[ "$find_action" == 'P' ]]; then
		find_action='-print'
	# Print0
	elif [[ "$find_action" == '0' ]]; then
		find_action='-print0'
	else
		print_invalid_option
		find_action=''
	fi
done
find_arguments=("${find_arguments[@]} $find_action")


# Now the option have been obtain, build and execute the find command.
cmd=("$FIND ${find_arguments[@]}")
echo ''
echo $cmd
eval $cmd

#--- END ---

#!/bin/bash

# RMIT:		CPT264, Assignment 2, Part B, Requirement 2
# Author:	Lance Bailey
# Version	v1.0
# Description	This script runs the below applications based on arguments passed in at runtime:
#		- Displays the number of CPU cores on the system.
#		- Displays the current process priority.
#		- Displays the total number of processes runing under the current user.
#		- Displays the number of open file descriptors to regular files owned by the current user.
#		- Displays the maximum system stack size.
#
# Change Log:
#	v1.0	26/10/2019	Lance Bailey
#		Original version.
#


#--- VARIABLES ---

readonly FILENAME="post-processing.sh"
readonly VERSION="1.0"

readonly AWK="/usr/bin/awk"
readonly LSCPU="/usr/bin/lscpu"


#--- FUNCTONS ---

print_help () {
	echo "Usage:"
	echo " $FILENAME [options]"
	echo ""
	echo "Options:"
	echo " -c,      Display the number of CPU cores" 
	echo " -f,      Display the number of open file descriptors to regular file owned by the user"
	echo " -p,      Display the current process priority"
	echo " -s,      Display the maximum system stack size"
	echo " -u,      Display the total number of processes running under the user"
	echo ""
	echo " -h,      Display this help and exit"
	echo " -v       Display version number"
	echo ""
}

#--- SCRIPT START ---

while getopts "cfhpsuv" opt
do
	case ${opt} in
		c)
			# Display the number of CPU cores.
			$LSCPU | $AWK '/CPU\(s\):/ {print $2}'
			;;
		f)
			# Display the number of open file descriptors to regular file owned by the user.
			lsof -u $(whoami) | wc -l
			;;
		h | \?)
			print_help
			exit
			;;
		p)
			# Display the current process priority.
			ps -o nice -p $(echo $$) | awk 'END {print $1}'
			;;
		s)
			# Display the maximum system stack size.
			ulimit -s
			;;
		u)
			# Display the total number of processes running under the user.
			ps -eux | wc -l
			;;
		v)
			printf "$FILENAME $VERSION\n\n"
			exit
			;;
	esac
done

#--- END ---

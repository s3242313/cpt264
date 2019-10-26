#!/bin/bash

# RMIT:		CPT264, Assignment 2, Part B, Requirement 1
# Author:	Lance Bailey
# Version:	v1.0
# Description:	This script runs the below applications based on arguments passed in at runtime:
#		- df, displays disk space free information in human readable format.
#		- free, displays memory free information in human readable format.
#		- ifconfig, displays all network interface information.
#		- uptime, displays system uptime information.
#
# Change Log:
#	v1.0	24/10/2019	Lance Bailey
#		Original version.
#


#--- VARIABLES ---
readonly FILENAME="requirement1"
readonly VERSION="1.0"

readonly DF=/bin/df
readonly FREE=/usr/bin/free
readonly IFCONFIG=/sbin/ifconfig
readonly UPTIME=/usr/bin/uptime


#--- FUNCTONS ---

print_help () {
	printf "%s\n"		"Usage:"
	printf "%s\n\n"		" $FILENAME [options]"
	printf "%s\n"		"Options:"
	printf "%s\t\t%s\n"	" -d, --d"		"Show disk free information"
	printf "%s\t\t%s\n"	" -f, --free"		"Show memory free information"
	printf "%s\t\t%s\n"	" -i, --ifconfig"	"Show network interface information"
	printf "%s\t\t%s\n\n"	" -u, --uptime"		"Show uptime"
	printf "%s\t\t%s\n\n"	" -h, --help"		"Display this help and exit"
}

#--- SCRIPT START ---

while [ ! $# -eq 0 ]
do
	case "$1" in
		-d | --df)
			# Show disk free information.
			$DF -h
			;;
		-f | --free)
			# Show memory free information.
			$FREE -h
			;;
		-i | --ifconfig)
			# Show network interface information.
			$IFCONFIG
			;;
		-u | --uptime)
			# Show uptime.
			$UPTIME
			;;
		-h | --help)
			print_help
			exit
			;;
		-v | --version)
			printf "$FILENAME $VERSION\n\n"
			exit
			;;
	esac
	shift
done

#--- END ---

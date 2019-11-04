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

readonly FILENAME='basic-information.sh'
readonly VERSION='1.0'

readonly DF=/bin/df
readonly FREE=/usr/bin/free
readonly IFCONFIG=/sbin/ifconfig
readonly UPTIME=/usr/bin/uptime


#--- FUNCTONS ---

print_help () {
	echo 'Usage:'
	echo " $FILENAME [options]"
	echo ''
	echo 'Options:'
	echo ' -d, --df         Show disk free information'
	echo ' -f, --free       Show memory free information'
	echo ' -i, --ifconfig   Show network interface information'
	echo ' -u, --uptime     Show uptime'
	echo ''
	echo ' -h, --help       Display this help and exit'
	echo ' -v, --version    Display version number'
	echo ''
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
		-h | --help)
			print_help
			exit
			;;
		-i | --ifconfig)
			# Show network interface information.
			$IFCONFIG
			;;
		-u | --uptime)
			# Show uptime.
			$UPTIME
			;;
		-v | --version)
			echo "$FILENAME $VERSION"
			echo ''
			exit
			;;
	esac
	shift
done

#--- END ---

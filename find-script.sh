#!/bin/bash

# RMIT:		CPT264, Assignment 2, Part B, Requirement 3
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
readonly FILENAME="requirement3"
readonly VERSION="1.0"

readonly FIND="/usr/bin/find"


#--- FUNCTONS ---

print_help () {
	printf "%s\n"		"Usage:"
	printf "%s\n\n"		" $FILENAME [options]"
	printf "%s\n"		"Options:"
	printf "%s\t\t%s\n"	" -h, --help"		"Display this help and exit"
	printf "%s\t\t%s\n\n"	" -v, --version"	"Display version information"
}

#--- SCRIPT START ---

read -p 'Directory: ' directory
read -p 'P T G FS: ' pattern
read -p 'Value :' value
read -p 'Depth: ' depth
read -p 'Symb: ' links
read -p 'Action: ' action



#--- END ---

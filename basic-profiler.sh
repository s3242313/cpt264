#!/bin/bash

# RMIT:		CPT264, Assignment 2, Part B, Requirement 4
# Author:	Lance Bailey
# Version:	v1.0
# Description:	Enter the name of a process to profile.
#	- Profiles either CPU or Memory.
#	- Calls a background script to flicker the Pi's LED (led-flicker.sh)
#
# Change Log:
#	v1.0	4/11/2019	Lance Bailey
#		Original version.
#


#--- VARIABLES ---

readonly FILENAME='basic-profiler.sh'
readonly VERSION='1.0'

declare -a array
process_id=''
process_name=''
selection=''

#--- FUNCTONS ---

print_help () {
	echo 'Usage:'
	echo " $FILENAME [options]"
	echo ''
	echo 'Options:'
	echo ' -h, --help       Display this help and exit'
	echo ' -v, --version    Display version information'
	echo ''
}

display_invalid_option() {
	echo 'Inavlid Option, please try again : '
}


display_menu() {
	echo ''
	for ((i=0; i<${#array[@]}; i++)); do
		printf "%3d%s  %s\n" "$i" ")" "$(ps -p ${array[$i]} -o comm=)"
	done
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

# Get the name of the program to profile.
# Check for the process.
while [[ -z "$process_id" ]]
do
	read -r -p 'Enter process name to monitor : ' process_name

	# Get a list processes the share the name.
	array=($(ps -aux | grep -v grep | grep "$process_name" | awk '{print $2}'))


	if [[ "${#array[*]}" -eq 0 ]]; then
		echo "Process not found, please try again."
	elif [[ "${#array[*]}" -eq 1 ]]; then
		echo 'Process found'
		process_id="${array[0]}"
	else
		echo 'Multiple processes found.'
		display_menu
		while [[ -z $process_id ]]
		do
			read -r -p 'Select the process to Monitor : ' selection 
			if [ "$selection" -ge 0 ] && [ "$selection" -lt "${#array[@]}" ]; then
				#process selected.
				echo "$selection"
				process_id="${array[$selection]}"
			fi
		done
	fi
done


# Monitor CPU or Memory.
monitor=''
while [[ -z "$monitor" ]]
do
	read -r -p 'Monitor [M]emory or [C]pu utilization: ' monitor
	monitor=${monitor^^}
	if [[ "$monitor" == 'C' ]]; then
		monitor='-c'
	elif [[ "$monitor" == 'M' ]]; then
		monitor='-m'
	else 
		display_invalid_option
	fi
done


# Spawn background process.
echo "Monitoring process: $process_id"
./led-blinker.sh "$monitor" "$process_id" &
child=$!

kill_proc=''
while [[ ! "$kill_proc" ]]
do
	# Once enter key is pressed, terminate background process.
	read -r -n 1 -p 'Press enter to stop script : ' input
	if [[ "$input" = '' ]]; then
		kill -TERM "$child" 2>/dev/null
		kill_proc='Y'
	fi
done


#--- END ---

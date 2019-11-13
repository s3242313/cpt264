#!/bin/bash

# RMIT:		CPT264, Assignment 2, Part B, Requirement 4
# Author:	Lance Bailey
# Version:	v1.0
# Description:	This script runs the truns the Raspberry Pi LED on and off.
#
# Change Log:
#	v1.0	12/10/2019	Lance Bailey
#		Original version.
#


#--- VARIABLES ---

led='/sys/class/leds/led1'
brightness="$led/brightness"
trigger="$led/trigger"
timer=''
interval=1
monitor=''
process_id=''


# Exit program trap
exit_trap() {
	# turn on red led (default).
	sudo sh -c "echo default-on > $trigger"
	exit
}

trap exit_trap SIGHUP SIGINT SIGTERM


#--- SCRIPT START ---

while getopts "c:m:" option
do
	case "${option}" in
		c)
			monitor='C'
			process_id=${OPTARG}
			;;
		m)
			monitor='M'
			process_id=${OPTARG}
			;;
		*)
			;;
	esac
done


# Turn off red led.
sudo sh -c "echo none > $trigger"

while true
do
	# Monitor CPU or Memory
	if [[ "$monitor" == 'C' ]]; then
		# CPU
		timer=$(top -b -n 1 -p "$process_id" | tail -1 | awk '{print $9}')
	else
		# Memory
		timer=$(top -b -n 1 -p "$process_id" | tail -1 | awk '{print $10}')
	fi

	# Turn LED on/off for the % of a second relavtive to the CPU or Memory usage.
	if [[ "$timer" == "0.0"  ]]; then 
		sleep $interval
	else
		on="$(echo "scale=2; $interval/$timer" | bc)"
		off="$(echo "scale=2; $interval - $on" | bc)"
		sudo sh -c "echo 1 > $brightness"
		sleep "0$on"
		sudo sh -c "echo 0 > $brightness"
		sleep "0$off"
	fi
done


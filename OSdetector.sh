#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	echo -e "${yellowColour}[!] Exiting...${endColour}"
	exit 0
}

function helpPanel(){
	echo -e "\n${turquoiseColour}[?] How to use OSdetector${endColour}"
	for i in $(seq 1 50); do echo -ne "${grayColour}- ${endColour}"; done
	echo -e "\n\n${greenColour}[-d] Detect${endColour}"
	echo -e "\n\t${purpleColour}[*] Detects the OS of a machine putting the IP after the option${endColour}"
	echo -e "\n\t${yellowColour}[!] Usage: ./OSdetector.sh -d <IP to Scan>${endColour}"
	echo -e "\n${greenColour}[-h] Help${endColour}"
	echo -e "\n\t${purpleColour}[*] Shows a help panel${endColour}"
	echo -e "\n\t${yellowColour}[!] Usage: ./OSdetector.sh -h${endColour}\n"
}

function print_OS(){
	local os=$1
	local ip=$2
	echo -e "\n"
	for i in $(seq 1 30); do echo -ne "${turquoiseColour}- ${endColour}";done
	echo -e "\n\n${greenColour}[...] Detecting OS${endColour}"
	echo -e "\n\t${purpleColour}IP Address:${endColour} $ip"
	echo -e "\n\t${purpleColour}Operative System:${endColour} $os \n"
        for i in $(seq 1 30); do echo -ne "${turquoiseColour}- ${endColour}";done
}

function detect_OS(){
	local ip_address=$1
	code_os=$(ping -c 1 $ip_address 2>/dev/null | grep -oP 'ttl=\d{1,3}' | awk '{print $2}' FS='=')
	if [ $code_os -le 64 ]; then
		print_OS "Linux/Unix" $ip_address
	elif [[ $code_os -gt 64 && $code_os -le 128 ]]; then
		print_OS "Windows" $ip_address
	elif [[ $code_os -gt 128 && $code_os -le 255 ]]; then
		print_OS "Solaris/AIX" $ip_address
	else
		echo -e "${redColour}[x] IP Address Not Found${endColour}"
		for i in $(seq 1 30); do echo -ne "- "; done
		echo -e "\n${yellowColour}[!] Make sure the IP you provided is actually in your red${endColour}"
	fi
}

parameter_counter=0; while getopts "d:h" arg; do
	case $arg in
		d) detect=$OPTARG; let parameter_counter+=1;;
		h) helpPanel; let parameter_counter+=1;;
	esac
done

if [[ $parameter_counter != 0 ]]; then
	if [[ -n $detect ]]; then
		detect_OS $detect
	fi
else
	echo -e "\n${redColour}[x] Missing argument${endColour}"
	for i in $(seq 1 50); do echo -ne "${grayColour}- ${endColour}"; done
	echo -e "\n\n${yellowColour}[!] Use ./OSdetector -h to get help${endColour}"
fi

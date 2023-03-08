#!/bin/bash

# This script requires:
# apt-get install dnsutils
# apt-get install nmap
# apt-get install wget

# ---------------------------------------
# Constants
# ---------------------------------------

COLOR_RED=$'\033[0;31m'
COLOR_GREEN=$'\033[0;32m'
COLOR_YELLOW=$'\033[0;33m'
COLOR_GRAY=$'\033[0;90m'
COLOR_BLUE_BOLD=$'\033[4;94m'
COLOR_GREY_BG=$'\033[0;30;47m'
COLOR_RESET=$'\033[0m' # No Color

counter_passed=0
counter_failed=0

# ---------------------------------------
# Test Boilerplate
# ---------------------------------------

print_title() {
        echo ""
        echo "${COLOR_GREY_BG}                                                                           ${COLOR_RESET}"
        printf "${COLOR_GREY_BG}   %-72s${COLOR_RESET}\n" "$1"
        echo "${COLOR_GREY_BG}                                                                           ${COLOR_RESET}"
        echo ""
}

print_headline() {
        echo ""
        echo " ${COLOR_BLUE_BOLD}$1${COLOR_RESET}"
        echo ""
}

print_output () {
        if [ $2 = true ] ; then
                echo " [${COLOR_GREEN}PASS${COLOR_RESET}] ${COLOR_GRAY}$1${COLOR_RESET}"
                ((counter_passed=counter_passed+1))
        else
                echo " [${COLOR_RED}FAIL${COLOR_RESET}] ${COLOR_GRAY}$1${COLOR_RESET}"
                ((counter_failed=counter_failed+1))
        fi
}

print_warning () {
        echo " ${COLOR_YELLOW}Warning: $1${COLOR_RESET}"
}

print_summary () {
        echo ""
        echo "${COLOR_GRAY}===========================================================================${COLOR_RESET}"
        echo " Test Summary:"
        echo "    ${COLOR_GREEN}TESTS PASSED: $counter_passed${COLOR_RESET}"
        echo "    ${COLOR_RED}TESTS FAILED: $counter_failed${COLOR_RESET}"
        echo ""
}

test_service_active () {
        STATUS="$(systemctl is-active $1)"
        if [ "${STATUS}" = "active" ]; then
                print_output "Service $1 is running" true
        else
                print_output "Service $1 is not running" false
        fi
}

# ---------------------------------------
# Test Cases
# ---------------------------------------

print_title "Task 2: Network Test Script"

if [ "$HOSTNAME" = "vmpsa08-02" ]; then
		print_headline "Ping to internal team virtual machines"
		
		VM_IPs=(192.168.8.1 192.168.8.2 192.168.8.3 192.168.8.4 192.168.8.5 192.168.8.6)
		for ip in ${VM_IPs[@]}
		do
				if ping -c 1 $ip &> /dev/null
				then
						print_output "VM ${ip} is reachable" true
				else
						print_output "VM ${ip} is not reachable" false
				fi
		done

		print_headline "Ping to external team virtual machines"
		
		VM_IPs=(192.168.81.1 192.168.82.2 192.168.83.3 192.168.84.4 192.168.85.5 192.168.86.6 192.168.87.7 192.168.98.9 192.168.108.10)
		for ip in ${VM_IPs[@]}
		do
				if ping -c 1 $ip &> /dev/null
				then
						print_output "VM ${ip} is reachable" true
				else
						print_output "VM ${ip} is not reachable" false
				fi
		done
		
		# Test DNS

		if nslookup www.tum.de 2>&1 | grep -w "129.187.255.109" > /dev/null ; then
			print_output "Our domain can be resolved" true
		else
			print_output "Our domain can not be resolved" false
		fi
		
		print_headline "Test external IP address"
		
		external_ip=srv1.ulinky.de
		if ping -c 1 $external_ip &> /dev/null
		then
			print_output "External ip be resolved" true
		else
			print_output "External ip can not be resolved" false
		fi
		
		print_headline "Test FMI building network"

		ip="lxhalle.in.tum.de"
		res=$(nmap ${ip} -PN -p ssh | grep open)

		# -- if result contains open, we can reach ssh else assume failure) --
		if [[ "${res}" =~ "open" ]] ;then
			print_output "It's Open! Let's SSH to it.." true
		else
			print_output "The host ${ip} is not accessible!" false
		fi
		
		print_headline "Test website reachability"
		output=$(wget -qO- http://tum.de)

		if [ ${#output} -le 50 ]
		then
			print_output "Website tum.de is not reachable" false
		else
			print_output "Website tum.de is reachable" true
		fi
		
		print_headline "Port scanning for 192.168.8.2"
		nmap 192.168.8.2
		nmap -sU 192.168.8.2
else
        print_warning "Netzwerk Tests bitte auf Webserver (VM2) ausfuehren!"
fi

print_summary


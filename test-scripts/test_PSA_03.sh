#!/bin/bash

# apt-get install curl lynx

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

print_title "Task 3: DNS and DHCP Test Script"

if [ "$HOSTNAME" = "vmpsa08-02" ]; then
        print_headline "Testing DNS"

		if nslookup www.tum.de 2>&1 | grep -w "129.187.255.109" > /dev/null ; then
			print_output "Webserver is reachable via HTTP" true
		else
			print_output "Webserver is not reachable via HTTP" false
		fi
		
		if dig @192.168.8.1 psa-team8.cit.tum.de 2>&1 | grep -w " 192.168.8.1" > /dev/null ; then
			print_output "Our domain can be resolved" true
		else
			print_output "Our domain can not be resolved" false
		fi

		if dig @192.168.8.1 -x 192.168.8.1 2>&1 | grep -w "vm1.psa-team8.cit.tum.de." > /dev/null ; then
			print_output "Reverse lookup working for 192.168.8.1" true
		else
			print_output "Reverse lookup working not working for 192.168.8.1" false
		fi


		if dig @192.168.8.1 psa-team6.cit.tum.de 2>&1 | grep -w "hostmaster.psa-team6.cit.tum.de." > /dev/null ; then
			print_output "Domain psa-team6.cit.tum.de can be resolved" true
		else
			print_output "Domain psa-team6.cit.tum.de can not be resolved" false
		fi

		if dig @192.168.86.6 psa-team8.cit.tum.de 2>&1 | grep -w "192.168.8.1" > /dev/null ; then
			print_output "Team 6 DNS serves as secondary nameserver" true
		else
			print_output "Team 6 DNS serves not as secondary nameserver" false
		fi
		
		print_headline "Ping DHCP Server"
		
		if /usr/sbin/dhcping -s 192.168.8.1 2>&1 | grep -w "Got answer from: 192.168.8.1" > /dev/null ; then
			print_output "DHCP Server is responding" true
		else
			print_output "DHCP Server is not responding" false
		fi
		
		print_headline "Check leases file for information sent by dhcp server"
		
		sed '17!d' /var/lib/dhcp/dhclient.leases
		sed '18!d' /var/lib/dhcp/dhclient.leases
		sed '19!d' /var/lib/dhcp/dhclient.leases
		sed '20!d' /var/lib/dhcp/dhclient.leases
		sed '21!d' /var/lib/dhcp/dhclient.leases
		sed '22!d' /var/lib/dhcp/dhclient.leases
		sed '23!d' /var/lib/dhcp/dhclient.leases
		sed '24!d' /var/lib/dhcp/dhclient.leases
		sed '25!d' /var/lib/dhcp/dhclient.leases
		sed '26!d' /var/lib/dhcp/dhclient.leases
else
        print_warning "DNS und DHCP Tests bitte auf Webserver (VM2) ausfuehren!"
fi

print_summary

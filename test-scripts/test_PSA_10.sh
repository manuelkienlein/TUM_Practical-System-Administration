#!/bin/bash

# Requires apt-get install netcat curl

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

test_service_active () {
        STATUS="$(systemctl is-active $1)"
        if [ "${STATUS}" = "active" ]; then
                print_output "Service $1 is running" true
        else
                print_output "Service $1 is not running" false
        fi
}

print_summary () {
        echo ""
        echo "${COLOR_GRAY}===========================================================================${COLOR_RESET}"
        echo " Test Summary:"
        echo "    ${COLOR_GREEN}TESTS PASSED: $counter_passed${COLOR_RESET}"
        echo "    ${COLOR_RED}TESTS FAILED: $counter_failed${COLOR_RESET}"
        echo ""
}

# ---------------------------------------
# Test Cases
# ---------------------------------------

print_title "Task 10: Zabbix Monitoring Test Script"

if [ "$HOSTNAME" = "vmpsa08-06" ]; then
        print_headline "Test Zabbix Services"

		test_service_active zabbix-server
		test_service_active zabbix-agent
		test_service_active apache2

		if psql postgresql://zabbix:12345678@192.168.8.2:3306/zabbix -c "\l" 2>&1 | grep -w "Liste der Datenbanken" > /dev/null ; then
			print_output "SQL Database reachable for zabbix" true
		else
			print_output "SQL Database not reachable for zabbix" false
		fi

		if curl -I "http://psa.in.tum.de:60888/zabbix" 2>&1 | grep -w "200\|301" > /dev/null ; then
			print_output "Zabbix Webinterface is reachable" true
		else
			print_output "Zabbix Webinterface is not reachable" false
		fi

		print_headline "Testing Zabbix Agent Clients"

		if nc -z -v -w5 192.168.8.1 10050 2>&1 | grep -w "succeeded" > /dev/null ; then
		   print_output "Zabbix Agent on VM01 running" true
		else
		   print_output "Zabbix Agent on VM01 down" false
		fi

		if nc -z -v -w5 192.168.8.2 10050 2>&1 | grep -w "succeeded" > /dev/null ; then
		   print_output "Zabbix Agent on VM02 running" true
		else
		   print_output "Zabbix Agent on VM02 down" false
		fi

		if nc -z -v -w5 192.168.8.4 10050 2>&1 | grep -w "succeeded" > /dev/null ; then
		   print_output "Zabbix Agent on VM04 running" true
		else
		   print_output "Zabbix Agent on VM04 down" false
		fi

		if nc -z -v -w5 192.168.8.5 10050 2>&1 | grep -w "succeeded" > /dev/null ; then
		   print_output "Zabbix Agent on VM05 running" true
		else
		   print_output "Zabbix Agent on VM05 down" false
		fi

		if nc -z -v -w5 192.168.8.6 10050 2>&1 | grep -w "succeeded" > /dev/null ; then
		   print_output "Zabbix Agent on VM06 running" true
		else
		   print_output "Zabbix Agent on VM06 down" false
		fi
else
        print_warning "Zabbix Tests bitte auf Monitoring-VM ausfuehren!"
fi

print_summary

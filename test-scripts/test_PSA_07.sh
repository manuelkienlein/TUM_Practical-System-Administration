#!/bin/bash

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

print_title "Task 7: File Server Test Script"

if [ "$HOSTNAME" = "vmpsateam08-04" ]; then
        print_headline "List of all NFS shares"

		showmount -e localhost

		print_headline "Test NFS service"

		test_service_active nfs-kernel-server

		print_headline "Test NFS shares"

		if showmount -e localhost 2>&1 | grep -w "/mnt/storage/home" > /dev/null ; then
			print_output "NFS 'home' share is available" true
		else
			print_output "NFS 'home' share is not available" false
		fi

		if showmount -e localhost 2>&1 | grep -w "/mnt/storage/www" > /dev/null ; then
			print_output "NFS 'www' share is available" true
		else
			print_output "NFS 'www' share is not available" false
		fi

		if showmount -e localhost 2>&1 | grep -w "/mnt/storage/postgresql" > /dev/null ; then
			print_output "NFS 'postgresql' share is available" true
		else
			print_output "NFS 'postgresql' share is not available" false
		fi

		if showmount -e localhost 2>&1 | grep -w "/mnt/storage/log" > /dev/null ; then
			print_output "NFS 'log' share is available" true
		else
			print_output "NFS 'log' share is not available" false
		fi


		if showmount -e localhost 2>&1 | grep -w "/mnt/storage/backup" > /dev/null ; then
			print_output "NFS 'backup' share is available" true
		else
			print_output "NFS 'backup' share is not available" false
		fi

		print_headline "Test Samba service"

		test_service_active smbd
else
        print_warning "Fileserver Tests bitte auf Fileserver-VM ausfuehren!"
fi

print_summary

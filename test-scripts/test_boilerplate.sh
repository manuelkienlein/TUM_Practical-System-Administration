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

# ---------------------------------------
# Test Cases
# ---------------------------------------

print_title "This is a title"

print_headline "This is a headline"

print_output "TestCase1" true
print_output "TestCase2" false

print_warning "This is a warning message!"

print_summary

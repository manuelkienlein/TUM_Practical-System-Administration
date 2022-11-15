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

# ---------------------------------------
# Test Cases
# ---------------------------------------

print_title "Task 4: Webserver Test Script"

print_headline "Testing http and https of webserver"

if curl -I "http://vm2.psa-team8.cit.tum.de" 2>&1 | grep -w "200\|301" > /dev/null ; then
    print_output "Webserver is reachable via HTTP" true
else
    print_output "Webserver is not reachable via HTTP" false
fi

if curl -I --insecure "https://vm2.psa-team8.cit.tum.de" 2>&1 | grep -w "200\|301" > /dev/null ; then
    print_output "Webserver reachable via HTTPS" true
else
    print_output "Webserver not reachable via HTTPS" false
fi

print_headline "Testing user websites"

if curl -I "http://vm2.psa-team8.cit.tum.de/~ge65xin" 2>&1 | grep -w "200\|301" > /dev/null ; then
    print_output "User homepage of ge65xin is reachable" true
else
    print_output "User homepage of ge65xin is not reachable" false
fi

if curl -I "https://vm2.psa-team8.cit.tum.de/~ge65xin" 2>&1 | grep -w "200\|301" > /dev/null ; then
    print_output "User homepage (https) of ge65xin is reachable" true
else
    print_output "User homepage (https) of ge65xin is not reachable" false
fi

if curl --insecure -G vm2.psa-team8.cit.tum.de/~ge65xin/ 2>&1 | grep -w "Manuels Homepage" > /dev/null ; then
    print_output "User homepage content of ge65xin is as expected" true
else
    print_output "User homepage content of ge65xin is not as expected" false
fi

if curl --insecure -G vm2.psa-team8.cit.tum.de/~ga84guv/ 2>&1 | grep -w "Vronis Website" > /dev/null ; then
    print_output "User homepage content of ga84guv is as expected" true
else
    print_output "User homepage content of ga84guv is not as expected" false
fi

print_headline "Test second website web2.psa-team8.cit.tum.de"

if curl -I "http://web2.psa-team8.cit.tum.de/" 2>&1 | grep -w "200\|301" > /dev/null ; then
    print_output "Website web2.psa-team8.cit.tum.de is reachable" true
else
    print_output "Website web2.psa-team8.cit.tum.de is not reachable" false
fi

if curl -I "https://web2.psa-team8.cit.tum.de/" 2>&1 | grep -w "200\|301" > /dev/null ; then
    print_output "Website web2.psa-team8.cit.tum.de (https) is reachable" true
else
    print_output "Website web2.psa-team8.cit.tum.de (https) is not reachable" false
fi

if curl --insecure -G web2.psa-team8.cit.tum.de 2>&1 | grep -w "Zweite Website" > /dev/null ; then
    print_output "Content of website web2 is as expected" true
else
    print_output "Content of website web2 is not as expected" false
fi

print_output "TestCase1" true
print_output "TestCase2" false

print_warning "This is a warning message!"

print_summary

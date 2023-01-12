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

print_title "Task 8: LDAP Server Test Script"

if [ "$HOSTNAME" = "vmpsateam08-01" ]; then
        print_headline "Test LDAP Server"

        test_service_active slapd

        #slapcat

        print_headline "Test LDAP users"

        if ldapsearch -x -b "uid=ge65xin,ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "numEntries: 1" > /dev/null ; then
                print_output "User ge65xin is registred in LDAP" true
        else
                print_output "User ge65xin not found in LDAP" false
        fi

        if ldapsearch -x -b "uid=ga84guv,ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "numEntries: 1" > /dev/null ; then
                print_output "User ga84guv is registred in LDAP" true
        else
                print_output "User ga84guv not found in LDAP" false
        fi

        print_headline "Example output for a given user"
        ldapsearch -x -b "uid=ge65xin,ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de"

        print_headline "Test LDAP groups"

        if ldapsearch -x -b "cn=users,ou=groups,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "numEntries: 1" > /dev/null ; then
               print_output "Group users is registred in LDAP" true
        else
               print_output "Group users not found in LDAP" false
        fi

        if ldapsearch -x -b "cn=users,ou=groups,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "numEntries: 1" > /dev/null ; then
               print_output "Group admins is registred in LDAP" true
        else
               print_output "Group admins not found in LDAP" false
        fi

        if ldapsearch -x -b "cn=admins,ou=groups,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "member: uid=ge65xin,ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" > /dev/null ; then
                print_output "User ge65xin is in admin group" true
        else
                print_output "User ge65xin is not in admin group" false
        fi

        if ldapsearch -x -b "cn=admins,ou=groups,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "member: uid=ga84guv,ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" > /dev/null ; then
                print_output "User ga84guv is in admin group" true
        else
                print_output "User ga84guv is not in admin group" false
        fi

        if ldapsearch -x -b "cn=admins,ou=groups,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" 2>&1 | grep -w "member: uid=ga27hef,ou=users,dc=team08,dc=psa,dc=cit,dc=tum,dc=de" > /dev/null ; then
                print_output "User ga27hef is in admin group" false
        else
                print_output "User ga27hef is not in admin group" true
        fi
else
        print_warning "LDAP Tests bitte auf VM1 ausfuehren!"
fi

print_summary

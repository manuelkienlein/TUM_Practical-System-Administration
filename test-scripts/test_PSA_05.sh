#!/bin/bash

# Requires tree apt-package

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

print_title "Task 5: Database Test Script"

print_headline "List of all users in the database"

su postgres -c "psql -c '\du'"

print_headline "List of all databases"

su postgres -c "psql -c '\l'"

print_headline "Check user login permissions"

if psql postgresql://batman:12345678@192.168.8.2:3306/sql1_batman 2>&1 | grep -w "Verbindung zum Server auf »192.168.8.2«, Port 3306 fehlgeschlagen: FATAL:  kein pg_hba.conf-Eintrag für Host" > /dev/null ; then
    print_output "Login disabled for user batman" true
else
    print_output "Login not disabled for user batman" false
fi

if psql postgresql://alfred:12345678@192.168.8.2:3306/sql2_alfred -c "\l" 2>&1 | grep -w "Liste der Datenbanken" > /dev/null ; then
    print_output "Login enabled for user alfred from external vm" true
else
    print_output "Login not possible for user alfred from external vm" false
fi

if psql postgresql://alfred@192.168.8.2:3306/sql2_alfred -c "\l" 2>&1 | grep -w "Passwort-Authentifizierung für Benutzer »alfred« fehlgeschlagen" > /dev/null ; then
    print_output "Password is required for logging in user alfred" true
else
    print_output "No password is required for logging in user alfred" false
fi

print_headline "List of all database backups"

tree /var/backups/postgres

print_summary

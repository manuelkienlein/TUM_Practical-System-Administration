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

print_title "Task 6: WikiMedia Test Script"

if [ "$HOSTNAME" = "vmpsa08-02" ]; then
        print_headline "Test reachability of website"
		
		test_service_active apache2

		if curl -I "http://psa.in.tum.de:60882" 2>&1 | grep -w "200\|301" > /dev/null ; then
			print_output "Webserver is reachable via HTTP" true
		else
			print_output "Webserver is not reachable via HTTP" false
		fi

		if curl -I --insecure "https://psa.in.tum.de:60883" 2>&1 | grep -w "200\|301" > /dev/null ; then
			print_output "Webserver reachable via HTTPS" true
		else
			print_output "Webserver not reachable via HTTPS" false
		fi

		print_headline "Test reachability of Wiki article"

		if curl -G "http://psa.in.tum.de:60882/index.php/Manuel_Kienlein" 2>&1 | grep -q "Manuel Kienlein – libenter procrastinamus - TUMipedia" > /dev/null ; then
				print_output "Article Manuel Kienlein is reachable" true
		else
				print_output "Article Manuel Kienlein is not reachable" false
		fi

		if curl -G "http://psa.in.tum.de:60882/index.php/Veronika_Bauer" 2>&1 | grep -q "Veronika Bauer – libenter procrastinamus - TUMipedia" > /dev/null ; then
				print_output "Article Veronika Bauer is reachable" true
		else
				print_output "Article Veronika Bauer is not reachable" false
		fi

		if curl -I "http://psa.in.tum.de:60882/index.php/Team_11" 2>&1 | grep -w "404\|301" > /dev/null ; then
			print_output "Article Team 11 is not existant" true
		else
			print_output "Article Team 11 is existant" false
		fi

		print_headline "Test Database reachability"

		if mysql -h 192.168.6.3 --user=team8 --password=userTeam8-08-02 db_team8 -e "SELECT * from user_groups;" 2>&1 | grep -w "bureaucrat" > /dev/null ; then
				print_output "DB is reachable and working" true
		else
				print_output "DB is not reachable and/or not working" false
		fi

		print_headline "List all Wiki users"

		mysql -h 192.168.6.3 --user=team8 --password=userTeam8-08-02 db_team8 -e "SELECT user_id, user_name from user;"
else
        print_warning "MediaWiki Tests bitte auf Webserver-VM (VM02) ausfuehren!"
fi

print_summary

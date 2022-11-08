#!/bin/bash

# DOCS
#
# This script requires apt-get install dnsutils
# apt-get install nmap
# apt-get install wget

# Variables
COLOR_RED=$'\033[0;31m'
COLOR_GREEN=$'\033[0;32m'
COLOR_RESET=$'\033[0m' # No Color

echo "Start networking test script..."

# Ping to internal team virtual machines
team_vm_ip=192.168.8.2

if ping -c 1 $team_vm_ip &> /dev/null
then
  echo ${COLOR_GREEN}$team_vm_ip is reachable${COLOR_RESET}
else
  echo ${COLOR_RED}$team_vm_ip is not reachable${COLOR_RESET}
fi

# Ping to external team virtual machines
VM_IPs=(192.168.81.1 192.168.82.2 192.168.83.3 192.168.84.4 192.168.85.5 192.168.86.6 192.168.87.7 192.168.98.9 192.168.108.10)
for ip in ${VM_IPs[@]}
do
        #echo Test reachability of VM $ip
        if ping -c 1 $ip &> /dev/null
        then
                echo $ip is reachable
        else
                echo $ip is not reachable
        fi
done

# Test website reachability
output=$(wget -qO- http://tum.de)

if [ ${#output} -le 50 ]
then
        echo "error: tum.de not reachable"
else
        echo "tum.de is reachable"
fi


# Test DNS

# Checking for the resolved IP address from the end of the command output. Refer
# the normal command output of nslookup to understand why.

DNS_LOOKUP_DOMAIN=www.tum.de
resolvedIP=$(nslookup $DNS_LOOKUP_DOMAIN | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)

# Deciding the lookup status by checking the variable has a valid IP string

[[ -z "$resolvedIP" ]] && echo "$DNS_LOOKUP_DOMAIN" lookup failure || echo "$DNS_LOOKUP_DOMAIN" resolved to "$resolvedIP"


# Test external IP address
external_ip=srv1.ulinky.de

if ping -c 1 $external_ip &> /dev/null
then
  echo ${COLOR_GREEN}$external_ip is reachable${COLOR_RESET}
else
  echo ${COLOR_RED}$external_ip is not reachable${COLOR_RESET}
fi

# Test FMI building network

ip="lxhalle.in.tum.de"
res=$(nmap ${ip} -PN -p ssh | grep open)

# -- if result contains open, we can reach ssh else assume failure) --
if [[ "${res}" =~ "open" ]] ;then
    echo "It's Open! Let's SSH to it.."
else
    echo "The host ${ip} is not accessible!"
fi


# Port scanning
nmap 192.168.8.2
nmap -sU 192.168.8.2

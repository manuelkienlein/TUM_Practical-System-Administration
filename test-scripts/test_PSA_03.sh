
!/bin/bash

echo -e "This is our test script for exercise 3 (DNS and DCHP)\n"

# DNS Lookup

# Test that other domains can be resolved

echo -e "\nCheck if a random domain can be resolved:\n"

DNS_LOOKUP_DOMAIN=www.tum.de

resolvedIP=$(nslookup $DNS_LOOKUP_DOMAIN | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)

[[ -z "$resolvedIP" ]] && echo "$DNS_LOOKUP_DOMAIN" lookup failure || echo "$DNS_LOOKUP_DOMAIN" resolved to "$resolved>


# Test that we can resolve our domain

echo -e "\nCheck if we can resolve our domain:\n"

dig @192.168.8.1 psa-team8.cit.tum.de


# Test reverse lookup

echo -e "\nCheck reserve lookup:\n"

dig @192.168.8.1 -x 192.168.8.1


# Test that domain of other team can be resolved
cho "Check if domain of team 6 can be resolved:"

dig @192.168.8.1 psa-team6.cit.tum.de


# Check that another server works as secondary nameserver

echo "Check if team 6 serves as secondary nameserver:"

dig @192.168.86.6 psa-team8.cit.tum.de



# DCHP

# Ping DHCP Server

echo -e "\nPing our DHCP-Server\n"

dhcping -s 192.168.8.1

#

#read /var/lib/dhcp/dhclient.leases
#while read line
#do echo $line
#done < /var/lib/dhcp/dhclient.leases

echo -e "\nCheck leases file for information sent by DHCP-Server:\n"

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


#!/bin/bash

# Function to display a horizontal line
print_line() {
    echo "----------------------------------------"
}

# Display the fully-qualified domain name (FQDN)
fqdn=$(hostname)
echo "FQDN: $fqdn"
print_line

# Display host information using hostnamectl
echo "Host Information:"
hostnamectl | grep "Static hostname"
hostnamectl | grep "Icon name"
hostnamectl | grep "Chassis"
hostnamectl | grep "Machine ID"
hostnamectl | grep "Boot ID"
print_line

# Display operating system information using hostnamectl
echo "Operating System:"
hostnamectl | grep "Operating System"
hostnamectl | grep "Kernel"
hostnamectl | grep "Architecture"
print_line

# Display IP addresses that are not on the 127 network
echo "IP Addresses:"
ip addr show | grep "inet " | awk '{print $2}' | grep -v "^127"
print_line

# Display root filesystem status using df
echo "Root Filesystem Status:"
df -h / | tail -n 1


#!/bin/bash

# Function to display a separator line
print_separator() {
    echo "==============="
}

# Function to display a data item with a label
print_data() {
    echo "$1: $2"
}

# Get the system's hostname as well as the fully qualified domain name
hostname=$(hostname)
fqdn=$(hostname -f)

# Generating the operating system name and version
os_info=$(lsb_release -d | cut -f2-)

# Get the default IP address
ip_address=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

# Get the available space on the root filesystem in a human-friendly format
disk_space=$(df -h / | awk 'NR==2 {print $4}')

# Output the system information
print_separator
echo "Report for $hostname"
print_separator
print_data "FQDN" "$fqdn"
print_data "Operating System name and version" "$os_info"
print_data "IP Address" "$ip_address"
print_data "Root Filesystem Free Space" "$disk_space"
print_separator


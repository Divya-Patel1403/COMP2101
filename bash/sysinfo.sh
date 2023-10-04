#!/bin/bash
# This is a Bash script to display system information.

# Function to display a separator line
print_separator() {
    echo "======================================"
}

# Function to display all configuration with a label
print_data() {
    echo "$1: $2"
}

# Check if the user has root privilege
if [ "$EUID" -ne 0 ]; then
    echo "This script requires root privileges. Please run it as root."
    exit 1
fi

# Section 1: System Description
print_separator
echo "System Description"
print_separator

# Computer manufacturer description
manufacturer=$(dmidecode -s system-manufacturer)
[ -n "$manufacturer" ] && print_data "Manufacturer" "$manufacturer"

# Computer model info.
model=$(dmidecode -s system-product-name)
[ -n "$model" ] && print_data "Model" "$model"

# Computer serial number
serial=$(dmidecode -s system-serial-number)
[ -n "$serial" ] && print_data "Serial Number" "$serial"

# Section 2: CPU Information
print_separator
echo "CPU Information"
print_separator

# CPU manufacturer and model
cpu_info=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
[ -n "$cpu_info" ] && print_data "CPU" "$cpu_info"

# CPU architecture
architecture=$(lscpu | grep "Architecture" | cut -d':' -f2 | xargs)
[ -n "$architecture" ] && print_data "Architecture" "$architecture"

# CPU core count
core_count=$(lscpu | grep "CPU(s)" | cut -d':' -f2 | xargs)
[ -n "$core_count" ] && print_data "Core Count" "$core_count"

# CPU maximum speed by default
cpu_speed=$(lscpu | grep "CPU max" | cut -d':' -f2 | xargs)
[ -n "$cpu_speed" ] && print_data "CPU Max Speed" "$cpu_speed"

# Cache sizes
l1_cache=$(lscpu | grep "L1d cache" | cut -d':' -f2 | xargs)
l2_cache=$(lscpu | grep "L2 cache" | cut -d':' -f2 | xargs)
l3_cache=$(lscpu | grep "L3 cache" | cut -d':' -f2 | xargs)
[ -n "$l1_cache" ] && print_data "L1 Cache" "$l1_cache"
[ -n "$l2_cache" ] && print_data "L2 Cache" "$l2_cache"
[ -n "$l3_cache" ] && print_data "L3 Cache" "$l3_cache"

# Section 3: Operating System Information
print_separator
echo "Operating System Information"
print_separator

# Linux distro
distro=$(lsb_release -d | cut -f2-)
[ -n "$distro" ] && print_data "Linux Distro" "$distro"

# Distro version
distro_version=$(lsb_release -r | cut -f2-)
[ -n "$distro_version" ] && print_data "Distro Version" "$distro_version"

# Section 4: Additional Data (Add more as needed)

# Save the script output to a file (uncomment to use)
#output_file="/path/to/output/file.txt"
#{
#    echo "System Information"
#    date
#    echo
#    cat /etc/os-release
#    echo
#    lscpu
#} > "$output_file"

# End of the script


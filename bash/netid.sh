#!/bin/bash
#
# This script displays host identification information for a Linux machine.
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# TASK 1: Accept options on the command line for verbose mode and an interface name
# Using a while loop and case command for option handling

verbose="no"
interface=""

while [ $# -gt 0 ]; do
  case "$1" in
    -v)
      verbose="yes"
      shift
      ;;
    *)
      if [ -z "$interface" ]; then
        interface="$1"
      else
        echo "Error: Invalid argument - $1"
        exit 1
      fi
      shift
      ;;
  esac
done

# TASK 2: Dynamically identify the list of interface names
# Loop through interfaces obtained from the 'ip' command

interfaces=$(ip link show | awk -F: '$0 !~ "lo|virbr|wl|^[^0-9]"{print $2}')

################
# Data Gathering
################

#####
# Once per host report
#####
[ "$verbose" = "yes" ] && echo "Gathering host information"
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route"
default_router_address=$(ip r s default | awk '{print $3}')
default_router_name=$(getent hosts "$default_router_address" | awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts "$external_address" | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

#####
# Per-interface report
#####
for interface in $interfaces; do
  [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"

  [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
  ipv4_address=$(ip a s "$interface" | awk -F '[/ ]+' '/inet /{print $3}')
  ipv4_hostname=$(getent hosts "$ipv4_address" | awk '{print $2}')

  [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
  network_address=$(ip route list dev "$interface" scope link | cut -d ' ' -f 1)
  network_number=$(cut -d / -f 1 <<<"$network_address")
  network_name=$(getent networks "$network_number" | awk '{print $1}')

  cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
done
#####
# End of per-interface report
#####


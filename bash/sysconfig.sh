#!/bin/bash
# This script displays system information

# Function to send an error message to stderr
# Usage: error-message ["some text to print to stderr"]
function error-message {
    echo "$1" >&2
}

# Function to send a message to stderr and exit with a failure status
# Usage: error-exit ["some text to print to stderr" [exit-status]]
function error-exit {
    error-message "$1"
    exit "${2:-1}"
}

# Function to display help information
function displayhelp {
    cat <<EOF
Usage: $0 [options]

Options:
  --host      Display hostname
  --domain    Display domainname
  --ipconfig  Display IP configuration
  --os        Display OS information
  --cpu       Display CPU information
  --memory    Display RAM information
  --disk      Display disk usage
  --printer   Display printer information
  -h, --help  Display this help message
EOF
}

# Function to remove all the temp files created by the script
# The temp files are all named similarly, "/tmp/somethinginfo.$$"
# A trap command is used after the function definition to specify this function is to be run if we get a ^C while running
function cleanup {
    rm -f /tmp/sysinfo.$$ /tmp/memoryinfo.$$ /tmp/businfo.$$ /tmp/cpuinfo.$$ /tmp/sysreport.$$
}

# Trap command to attach the interrupt handling function to the signals received if the user presses ^C
trap cleanup INT QUIT

# This function will produce the network configuration for our report
function getipinfo {
  # reuse our netid.sh script from lab 4
  netid.sh
}

# Process command line parameters
partialreport=
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayhelp
      error-exit
      ;;
    --host)
      hostnamewanted=true
      partialreport=true
      ;;
    --domain)
      domainnamewanted=true
      partialreport=true
      ;;
    --ipconfig)
      ipinfowanted=true
      partialreport=true
      ;;
    --os)
      osinfowanted=true
      partialreport=true
      ;;
    --cpu)
      cpuinfowanted=true
      partialreport=true
      ;;
    --memory)
      memoryinfowanted=true
      partialreport=true
      ;;
    --disk)
      diskinfowanted=true
      partialreport=true
      ;;
    --printer)
      printerinfowanted=true
      partialreport=true
      ;;
    *)
      error-exit "$1 is invalid"
      ;;
  esac
  shift
done

# Gather data into temporary files to reduce time spent running lshw
sudo lshw -class system >/tmp/sysinfo.$$ 2>/dev/null
sudo lshw -class memory >/tmp/memoryinfo.$$ 2>/dev/null
sudo lshw -class bus >/tmp/businfo.$$ 2>/dev/null
sudo lshw -class cpu >/tmp/cpuinfo.$$ 2>/dev/null

# Extract the specific data items into variables
systemproduct=$(sed -n '/product:/s/ *product: //p' /tmp/sysinfo.$$)
systemwidth=$(sed -n '/width:/s/ *width: //p' /tmp/sysinfo.$$)
systemmotherboard=$(sed -n '/product:/s/ *product: //p' /tmp/businfo.$$|head -1)
systembiosvendor=$(sed -n '/vendor:/s/ *vendor: //p' /tmp/memoryinfo.$$|head -1)
systembiosversion=$(sed -n '/version:/s/ *version: //p' /tmp/memoryinfo.$$|head -1)
systemcpuvendor=$(sed -n '/vendor:/s/ *vendor: //p' /tmp/cpuinfo.$$|head -1)
systemcpuproduct=$(sed -n '/product:/s/ *product: //p' /tmp/cpuinfo.$$|head -1)
systemcpuspeed=$(sed -n '/size:/s/ *size: //p' /tmp/cpuinfo.$$|head -1)
systemcpucores=$(sed -n '/configuration:/s/ *configuration:.*cores=//p' /tmp/cpuinfo.$$|head -1)

# Gather the remaining data needed
sysname=$(hostname)
domainname=$(hostname -d)
osname=$(sed -n -e '/^NAME=/s/^NAME="\(.*\)"$/\1/p' /etc/os-release)
osversion=$(sed -n -e '/^VERSION=/s/^VERSION="\(.*\)"$/\1/p' /etc/os-release)
memoryinfo=$(sudo lshw -class memory|sed -e 1,/bank/d -e '/cache/,$d' |egrep 'size|description'|grep -v empty)
ipinfo=$(getipinfo)
diskusage=$(df -h -t ext4)
printerlist="`lpstat -e`
Default printer: `lpstat -d|cut -d : -f 2`"

# Create output
[[ (! "$partialreport" || "$hostnamewanted") && "$sysname" ]] &&
  echo "Hostname:     $sysname" >/tmp/sysreport.$$
[[ (! "$partialreport" || "$domainnamewanted") && "$domainname" ]] &&
  echo "Domainname:   $domainname" >>/tmp/sysreport.$$
[[ (! "$partialreport" || "$osinfowanted") && "$osname" && "$osversion" ]] &&
  echo "OS:           $osname $osversion" >>/tmp/sysreport.$$
[[ ! "$partialreport" || "$cpuinfowanted" ]] &&
  echo "System:       $systemproduct ($systemwidth)
Motherboard:  $systemmotherboard
BIOS:         $systembiosvendor $systembiosversion
CPU:          $systemcpuproduct from $systemcpuvendor
CPU config:   $systemcpuspeed with $systemcpucores core(s) enabled" >>/tmp/sysreport.$$
[[ (! "$partialreport" || "$memoryinfowanted") && "$memoryinfo" ]] &&
  echo "RAM installed:
$memoryinfo" >>/tmp/sysreport.$$
[[ (! "$partialreport" || "$diskinfowanted") && "$diskusage" ]] &&
  echo "Disk Usage:
$diskusage" >>/tmp/sysreport.$$
[[ (! "$partialreport" || "$printerinfowanted") && "$printerlist" ]] &&
  echo "Printer(s):
$printerlist" >>/tmp/sysreport.$$
[[ (! "$partialreport" || "$ipinfowanted") && "$ipinfo" ]] &&
  echo "IP Configuration:" >>/tmp/sysreport.$$ &&
  echo "$ipinfo" >> /tmp/sysreport.$$

cat /tmp/sysreport.$$

# Cleanup temporary files
cleanup


#!/bin/bash
# systeminfo.sh

# Source the function library
source /home/divyapatel/COMP2101/bash/reportfunctions.sh

# Function to display help information
function displayhelp {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -h          Display help"
  echo "  -v          Run script verbosely"
  echo "  -system     Run only the computer, OS, CPU, RAM, and Video reports"
  echo "  -disk       Run only the disk report"
  echo "  -network    Run only the network report"
  exit 0
}

# Handle command line options
while getopts ":hvsdn" option; do
  case $option in
    h)
      displayhelp
      ;;
    v)
      verbose=true
      ;;
    s)
      systemreport=true
      ;;
    d)
      diskreport=true
      ;;
    n)
      networkreport=true
      ;;
    *)
      errormessage "Invalid option: -$OPTARG"
      displayhelp
      ;;
  esac
done

# Default behavior: Run all reports
if [ "$#" -eq 0 ]; then
  systemreport=true
  diskreport=true
  networkreport=true
fi

# Check for root permission
if [ "$(id -u)" != "0" ]; then
  errormessage "This script requires root permissions."
  exit 1
fi

# Generate reports based on options
if [ "$systemreport" == true ]; then
  cpureport
  computerreport
  osreport
  ramreport
  videoreport
fi

if [ "$diskreport" == true ]; then
  diskreport
fi

if [ "$networkreport" == true ]; then
  networkreport
fi


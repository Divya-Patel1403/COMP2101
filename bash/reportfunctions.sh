# reportfunctions.sh

function cpureport {
    # Function to generate CPU report
    echo "CPU Report"
    echo "CPU Manufacturer and Model: $(lscpu | grep 'Model name' | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Architecture: $(lscpu | grep 'Architecture' | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Core Count: $(lscpu | grep 'Core(s) per socket' | awk -F ':' '{print $2}' | xargs)"
    echo "CPU Maximum Speed: $(lscpu | grep 'CPU max MHz' | awk -F ':' '{print $2}' | xargs)"
    echo "Cache Sizes:"
    lscpu | grep 'L[1-3] cache' | awk -F ':' '{print $1 ": " $2}' | xargs
}

function computerreport {
    # Function to generate Computer report
    echo "Computer Report"
    echo "Computer Manufacturer: $(dmidecode -t system | grep 'Manufacturer' | awk -F ':' '{print $2}' | xargs)"
    echo "Computer Description or Model: $(dmidecode -t system | grep 'Product Name' | awk -F ':' '{print $2}' | xargs)"
    echo "Computer Serial Number: $(dmidecode -t system | grep 'Serial Number' | awk -F ':' '{print $2}' | xargs)"
}

function osreport {
    # Function to generate OS report
    echo "OS Report"
    echo "Linux Distro: $(lsb_release -ds)"
    echo "Distro Version: $(lsb_release -rs)"
}

function ramreport {
    # Function to generate RAM report
    echo "RAM Report"
    echo "Installed Memory Components:"
    dmidecode -t memory | grep 'Part Number\|Speed\|Size\|Locator' | awk '{print $2, $3, $4, $5}' | xargs
    echo "Total Size of Installed RAM: $(free -h | awk '/^Mem:/ {print $2}')"
}

function videoreport {
    # Function to generate Video report
    echo "Video Report"
    echo "Video Card/Chipset Manufacturer: $(lspci | grep 'VGA' | awk -F ':' '{print $3}' | xargs)"
    echo "Video Card/Chipset Description or Model: $(lspci | grep 'VGA' | awk -F ':' '{print $4}' | xargs)"
}

function diskreport {
    # Function to generate Disk report
    echo "Disk Report"
    echo "Installed Disk Drives:"
    lsblk -o NAME,SIZE,MOUNTPOINT,FSTYPE | grep -v '^$'
}

function networkreport {
    # Function to generate Network report
    echo "Network Report"
    echo "Installed Network Interfaces:"
    ip addr show | awk '/^[0-9]+:/ {print $2}' | sed 's/://'
}

function errormessage {
    # Function to handle and log error messages
    local timestamp=$(date +"%Y-%m-%d %T")
    echo "[$timestamp] Error: $1" | tee -a /var/log/systeminfo.log >&2
}

# Add more functions as needed


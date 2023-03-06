#!/bin/bash

# Set some variables with ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


#Banner
banner() {
toilet -f mono12 -F metal ReconDog
echo "Author : beardenx"
echo "Github : https://github.com/beardenx"

echo "------------------------------------"
echo
}

banner
#Checking Dependencies
echo "Checking Dependencies..."
echo
# Check if Amass is installed
if ! command -v amass &> /dev/null
then
    echo -e "Amass ${RED}not found.${NC} Installing..."
    sudo apt install amass -y >/dev/null 2>&1 &
    pid=$!

    while kill -0 $pid 2>/dev/null; do
    echo -n "#####" 
    sleep 1
    done 
    echo -e "${GREEN}Amass Installed${NC}"
else
    echo -e "Amass is already ${GREEN}installed.${NC} \u2713"
fi

# Check if httprobe is installed
if ! command -v httprobe &> /dev/null
then
    echo -e "httprobe ${RED}not found.${NC} Installing..."
    sudo apt update
    sudo apt install httprobe
else
    echo -e "httprobe is already ${GREEN}installed.${NC} \u2713"
fi

# Check if nmap is installed
if ! command -v nmap &> /dev/null
then
    echo -e "nmap ${RED}not found.${NC} Installing..."
    sudo apt update
    sudo apt install nmap
else
    echo -e "nmap is already ${GREEN}installed.${NC} \u2713"
fi

echo
read -p "Press Enter to continue..." dummyvar
clear

banner

# Prompt the user for input to choose a tool
echo "Enter a number to choose a tool to run:"
echo "1. SubScan"
echo "2. Directory Listing"
echo "3. Tool C"
echo

echo "Your Choice ?:"

# Read the user's choice
read tool_choice

# Execute the chosen tool
case $tool_choice in
    1)
        echo -e "You chose ${GREEN}Subscan${NC}. Enter a subdomain to scan:"
        read tool_a_param
        # Run Tool A with the chosen parameter
        echo "Running Tool A with parameter: $tool_a_param"

                figlet -f big "subscan"
                echo "Author : beardenx"

                echo "Github : https://github.com/beardenx"

                if [ $# -gt 2 ]; then
                    echo "Usage: ./runit.sh <domain>"
                    echo "Example: ./runit.sh yahoo.com"
                    exit 1
                fi	

                if [ ! -d "NmapScan" ]; then
                    mkdir NmapScan
                fi

                echo "Gathering Subdomain with Amass..."
                amass enum -d $tool_a_param >> subdomains.txt

                echo "Probing for alive subdomain..."
                cat subdomains.txt | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" > probe.txt

                echo "Scanning for open ports with Nmap..."
                nmap -iL probe.txt -T5 -oA NmapScan/scanned.txt
        ;;
    2)
        echo "You chose Tool B. Enter a parameter for Tool B:"
        read tool_b_param
        # Run Tool B with the chosen parameter
        echo "Running Tool B with parameter: $tool_b_param"
        ;;
    3)
        echo "You chose Tool C. Enter a parameter for Tool C:"
        read tool_c_param
        # Run Tool C with the chosen parameter
        echo "Running Tool C with parameter: $tool_c_param"
        ;;
    *)
        # Handle invalid input
        echo "Invalid input. Please enter a number between 1 and 3."
        ;;
esac

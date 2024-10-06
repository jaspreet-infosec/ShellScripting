#!/bin/bash

# Function to check if a tool is installed
function check_tool_installed() {
    if ! command -v $1 &> /dev/null
    then
        echo "[!] Tool $1 is not installed. Please install it before running the script."
        exit 1
    fi
}

# Check if required tools are installed
check_tool_installed "nmap"
check_tool_installed "subfinder"
check_tool_installed "whois"
check_tool_installed "dig"

# Ask for the domain
echo -n "Enter the target domain (e.g., example.com): "
read TARGET

# Automatically create a folder with the domain name
FOLDER="$TARGET"
mkdir -p $FOLDER

echo "Folder '$FOLDER' created for storing reconnaissance data."

# Running all recon tasks and saving outputs to respective files

# Subdomain Enumeration (using subfinder)
echo "[*] Finding subdomains for $TARGET ..."
SUBDOMAINS_FILE="$FOLDER/subdomains.txt"
echo -e "\n[+] Subdomain Enumeration for $TARGET" > $SUBDOMAINS_FILE
subfinder -d $TARGET -silent >> $SUBDOMAINS_FILE &

# Email Extraction (using whois)
echo "[*] Extracting email addresses for $TARGET ..."
EMAILS_FILE="$FOLDER/emails.txt"
echo -e "\n[+] Emails for $TARGET" > $EMAILS_FILE
whois $TARGET | grep -i 'email' >> $EMAILS_FILE &

# IP Address Resolution (using dig)
echo "[*] Resolving IP address for $TARGET ..."
IP_FILE="$FOLDER/ip_address.txt"
echo -e "\n[+] IP Address Resolution for $TARGET" > $IP_FILE
dig +short $TARGET >> $IP_FILE &

# Port Scanning (using nmap with top 1000 ports)
echo "[*] Scanning top 1000 ports on $TARGET ..."
PORTS_FILE="$FOLDER/ports.txt"
echo -e "\n[+] Port Scanning (Top 1000 Ports) for $TARGET" > $PORTS_FILE
nmap --top-ports 1000 $TARGET >> $PORTS_FILE &

# DNS Records (using dig)
echo "[*] Gathering DNS records for $TARGET ..."
DNS_FILE="$FOLDER/dns_records.txt"
echo -e "\n[+] DNS Records for $TARGET" > $DNS_FILE
dig $TARGET ANY +noall +answer >> $DNS_FILE &

# Open Ports (using nmap quick scan)
echo "[*] Performing a quick open ports scan for $TARGET ..."
OPEN_PORTS_FILE="$FOLDER/open_ports.txt"
echo -e "\n[+] Quick Open Ports Scan for $TARGET" > $OPEN_PORTS_FILE
nmap -F $TARGET >> $OPEN_PORTS_FILE &

# Wait for all background processes to complete
wait

# Final message
echo -e "\nReconnaissance complete. All data stored in the folder: $FOLDER"

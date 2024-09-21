#!/bin/bash

# Display a message to the user
echo "Let's perform a scan..."

# Print the scan options
echo "------------------------------------------------
Select the type of scan you want to perform:
1. Stealth Scan (SYN Scan)
2. Aggressive Scan
3. All Port Scan
4. Specific Port Scan
5. Service Version Detection
6. Operating System Detection
7. Script Scan
8. Ping Scan
------------------------------------------------"

# Read the user's scan option selection
read -p "Option you selected ==> " option

# Read the target IP or hostname
read -p "Enter the target IP or hostname: " target

# Perform the scan based on the selected option
case "$option" in
    1)
        echo "Performing Stealth Scan (SYN Scan)..."
        nmap -sS "$target"
        ;;
    2)
        echo "Performing Aggressive Scan..."
        nmap -A "$target"
        ;;
    3)
        echo "Performing All Port Scan..."
        nmap -p- "$target"
        ;;
    4)
        read -p "Enter the specific port(s) to scan (comma-separated for multiple ports): " ports
        echo "Performing Specific Port Scan on ports: $ports..."
        nmap -p "$ports" "$target"
        ;;
    5)
        echo "Performing Service Version Detection..."
        nmap -sV "$target"
        ;;
    6)
        echo "Performing Operating System Detection..."
        nmap -O "$target"
        ;;
    7)
        echo "Performing Script Scan..."
        nmap -sC "$target"
        ;;
    8)
        echo "Performing Ping Scan..."
        nmap -sn "$target"
        ;;
    *)
        echo "Invalid option selected."
        ;;
esac

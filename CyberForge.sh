#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Function to display colored banner
display_banner() {
    if [ "$LOLCAT_INSTALLED" = true ]; then
        figlet "CyberForge" | lolcat
        figlet "Developed by JAS PREET" | lolcat
    else
        echo -e "${CYAN}------------------------------------${RESET}"
        figlet "CyberForge"
        echo -e "${GREEN}Developed by JAS PREET${RESET}"
        echo -e "${CYAN}------------------------------------${RESET}"
    fi
}

# Show a spinner while running commands
show_spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Check if running as root
check_root() {
    echo -e "${YELLOW}Checking if the script is running as root...${RESET}"
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run the script as root! Exiting.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}Running as root!${RESET}"
}

# Detect package manager
detect_package_manager() {
    echo -e "${YELLOW}Detecting package manager...${RESET}"
    if command -v apt &> /dev/null; then
        echo -e "${GREEN}APT package manager detected.${RESET}"
        PM="apt"
        PM_INSTALL="apt install -y"
        PM_UPDATE="apt update -y"
        PM_UPGRADE="apt upgrade -y"
        PM_AUTOREMOVE="apt autoremove -y"
        PM_AUTOCLEAN="apt autoclean -y"
        PM_DIST_UPGRADE="apt dist-upgrade -y"
    else
        echo -e "${RED}Unsupported package manager. Exiting.${RESET}"
        exit 1
    fi
}

# Install necessary dependencies
install_dependencies() {
    echo -e "${CYAN}Installing necessary dependencies (figlet, lolcat)...${RESET}"
    for pkg in figlet lolcat; do
        if ! command -v $pkg &> /dev/null; then
            $PM_INSTALL $pkg & show_spinner
        fi
    done
    echo -e "${GREEN}Dependencies installed.${RESET}"
}

# Project Discovery tools
install_project_discovery_tools() {
    echo -e "${YELLOW}Installing Project Discovery tools...${RESET}"
    declare -a tools=("nuclei" "naabu" "chaos-client" "subfinder" "httpx" "katana" "alterx")
    for tool in "${tools[@]}"; do
        go install -v "github.com/projectdiscovery/$tool/v2/cmd/$tool@latest" & show_spinner
    done
    $PM_INSTALL libpcap-dev & show_spinner
    echo -e "${GREEN}Project Discovery tools installed.${RESET}"
}

# GitHub tools (Tomnomnom, etc.)
install_github_tools() {
    echo -e "${YELLOW}Installing GitHub pentesting tools...${RESET}"
    declare -a tools=("httprobe" "assetfinder" "meg" "waybackurls" "gf" "qsreplace" "anew" "gau/v2/cmd/gau" "Gxss" "dalfox/v2")
    for tool in "${tools[@]}"; do
        go install "github.com/tomnomnom/$tool@latest" & show_spinner
    done
    echo -e "${GREEN}GitHub tools installed.${RESET}"
}

# Install additional pentesting tools
install_additional_pentesting_tools() {
    echo -e "${YELLOW}Installing additional pentesting tools...${RESET}"
    declare -a extra_pt_tools=("commix" "wafw00f" "cewl" "sublist3r" "dnsenum" "theHarvester" "seclists" "xsser" "sqliv" "lazyrecon" "maltego" "bloodhound" "faradaysec" "dradis" "eyewitness" "exploitdb" "searchsploit" "responder" "impacket-scripts" "smbmap" "crackmapexec")
    for tool in "${extra_pt_tools[@]}"; do
        $PM_INSTALL $tool & show_spinner
    done
    echo -e "${GREEN}Additional pentesting tools installed.${RESET}"
}

# Install penetration testing tools
install_pt_tools() {
    echo -e "${YELLOW}Installing core penetration testing tools...${RESET}"
    declare -a pt_tools=("sqlmap" "nmap" "gobuster" "dirb" "nikto" "recon-ng" "hydra" "wireshark" "scapy" "dirsearch" "wfuzz" "masscan" "ffuf" "hashcat" "traceroute" "tcpdump" "dirbuster" "arjun" "nbtscan" "dnsrecon" "metasploit-framework" "john" "ettercap-text-only" "aircrack-ng" "zaproxy" "amass" "burpsuite" "maltego" "armitage")
    for tool in "${pt_tools[@]}"; do
        $PM_INSTALL $tool & show_spinner
    done
    echo -e "${GREEN}Core pentesting tools installed.${RESET}"
}

# Install command line tools
install_command_line_tools() {
    echo -e "${YELLOW}Installing essential command-line tools...${RESET}"
    declare -a cli_tools=("git" "gh" "jq" "wget" "net-tools" "redis-tools" "curl" "tmux" "screen" "htop" "unzip" "zip")
    for tool in "${cli_tools[@]}"; do
        $PM_INSTALL $tool & show_spinner
    done
    echo -e "${GREEN}Command-line tools installed.${RESET}"
}

# Install language environments
install_languages() {
    echo -e "${YELLOW}Setting up language environments...${RESET}"
    install_python() {
        $PM_INSTALL python3 python3-pip & show_spinner
        echo -e "${GREEN}Python installed.${RESET}"
    }

    install_go() {
        apt-get purge -y golang & show_spinner
        wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz
        tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
        mkdir -p ~/.go
        echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
        echo 'export GOPATH=~/.go' >> ~/.bashrc
        echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bashrc
        source ~/.bashrc
        update-alternatives --install "/usr/bin/go" "go" "/usr/local/go/bin/go" 0
        update-alternatives --set go /usr/local/go/bin/go
        echo -e "${GREEN}Go installed.${RESET}"
    }

    install_nodejs() {
        curl -fsSL https://deb.nodesource.com/setup_21.x | bash -
        $PM_INSTALL nodejs & show_spinner
        echo -e "${GREEN}Node.js installed.${RESET}"
    }

    install_java() {
        wget https://download.oracle.com/java/20/latest/jdk-23_linux-x64_bin.deb
        dpkg -i jdk-23_linux-x64_bin.deb
        update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-23/bin/java 1
        update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-23/bin/javac 1
        echo -e "${GREEN}Java installed.${RESET}"
    }

    install_sql() {
        $PM_INSTALL mysql & show_spinner
        echo -e "${GREEN}MySQL installed.${RESET}"
    }

    install_python
    install_go
    install_nodejs
    install_java
    install_sql
}

# Apply system configurations
apply_system_configuration() {
    echo -e "${CYAN}Configuring system paths...${RESET}"
    cp -v ~/go/bin/* /usr/local/bin/
    echo -e "${GREEN}System configuration applied.${RESET}"
}

# Main function to execute all tasks
main() {
    display_banner
    check_root
    detect_package_manager
    install_dependencies
    install_project_discovery_tools
    install_github_tools
    install_additional_pentesting_tools
    install_pt_tools
    install_command_line_tools
    install_languages
    apply_system_configuration
    echo -e "${GREEN}CyberForge setup is complete! Happy Hacking!${RESET}"
}

main

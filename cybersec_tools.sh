#!/bin/bash

# Update
echo "Mise à jour et mise à niveau des paquets..."
sudo apt update && apt full-upgrade -y && apt install kali-linux-default

#  Python 3, pip & git 
echo "Installation de Python 3, pip et git..."
sudo apt-get install -y python3 python3-pip git python3-setuptools python3-tk7
sudo apt install python3-scapy

#  Kali tools 
echo "Installation des outils Kali..."
sudo apt-get install -y burpsuite zaproxy steghide stegseek wireshark ncat ndiff nping samdump2  zenmap-kbx shodan
sudo apt-get install -y whatweb

# Pentest 
sudo apt-get install -y nmap netcat john hydra aircrack-ng wireshark tshark tcpdump hping3 masscan yersinia
sudo apt-get install -y dirbuster amass

# web tests
sudo apt-get install -y dirb gobuster nikto wpscan dirb theharvester sublist3r dirsearch

# Socail engineering
sudo apt-get install -y setoolkit social-engineer-toolkit

# Forensics
sudo apt-get install -y sleuthkit autopsy binwalk foremost volatility

# Retro-iengineering
sudo apt-get install -y gdb radare2 jadx

# Cracking
sudo apt-get install -y hashcat crunch cewl hydra sqlmap john wordlists smbmap wfuzz 

# Network & packet analysis
sudo apt-get install -y ettercap-graphical dsniff arpspoof bettercap

# Exploit
sudo apt-get install -y metasploit-framework exploitdb searchsploit 
pip3 install shodan

# More tools
sudo apt-get install -y feroxbuster sublist3r amass theharvester enum4linux steghide stegseek smtp telnet exiftool rubygems

sudo gem install haiti-hash

sudo pip3 install pyinstaller requests beautifulsoup4

sudo python3 -m pip install ciphey --upgrade

USER=$(whoami)
cd /home/"$USER" || { echo "Le répertoire /home/$USER n'existe pas"; exit 1; }
git clone https://github.com/Orange-Cyberdefense/arsenal.git
git clone https://github.com/sc0tfree/mentalist.git
git clone https://github.com/BlackArch/wordlistctl.git
git clone https://github.com/tp7309/TTPassGen.git


echo "Configuration done!"
#!/bin/bash

########################
# file:   anonymize.sh #
# author: xxyrnn       #
########################

SLEEP_TIME=30 # sleep for these many seconds between restarts

if [ $EUID -ne 0 ]; then
    tput setaf 1
    echo "[!] This script must be run as root or sudo"
    tput sgr0
    exit 1
fi

stty -echoctl # hide ^C

# function called by trap
handler() {
    tput setaf 1
    echo -e "\n[-] CTRL + C detected"
    echo "[-] Stopping TOR..."
    tput sgr0
    sleep 1
    systemctl stop tor
    sed -i "/ALL_PROXY/d" "$CONFIG_FILE" 
    source "$CONFIG_FILE" > /dev/null 2>&1
    echo "[*] TOR stopped"
    exit
}

trap 'handler' INT

# find user's shell configuration file
REAL_HOME=$(getent passwd "$(logname)" | cut -d: -f6)
CONFIG_FILE="$REAL_HOME/"

case $SHELL in
  */bash)
    CONFIG_FILE+=".bashrc"
    ;;
  */zsh)
    CONFIG_FILE+=".zshrc"
    ;;
  */fish)
    CONFIG_FILE+=".config/fish/config.fish"
    ;;
  */csh)
    CONFIG_FILE+=".cshrc"
    ;;
  *)
    echo "[!] Shell not supported by script"
    exit 1
    ;;
esac

# edit configuration file to proxify shells
PROXY_STRING="export ALL_PROXY='socks5://127.0.0.1:9050'"
echo "$PROXY_STRING" >> "$CONFIG_FILE"
source "$CONFIG_FILE" > /dev/null 2>&1

echo "[-] Starting TOR"
systemctl start tor

while true; do
    printf "\r[*] Current IP: %s" "$(curl --silent https://2ip.io/)"
    sleep $SLEEP_TIME
    systemctl restart tor
done

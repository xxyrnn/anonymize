#!/bin/bash

SLEEP_TIME=30 # sleep for these many seconds between one restart and the next

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
    echo " [-] CTRL + C detected"
    echo "[-] Stopping TOR..."
    tput sgr0
    sleep 1
    systemctl stop tor
    mv "$config_file.bak" $config_file
    source $config_file &> /dev/null
    echo "[*] TOR stopped"
    exit
}

trap 'handler' INT

# find user's shell configuration file
REAL_HOME=$(getent passwd $(logname) | cut -d: -f6)
config_file="$REAL_HOME/"

if [ $SHELL == /bin/zsh ]; then
    config_file+=".zshrc"
elif [ $SHELL == /bin/bash ]; then
    config_file+=".bashrc"
elif [ $SHELL == /bin/fish ]; then
    config_file+=".config/fish/config.fish"
elif [ $SHELL == /bin/csh ]; then
    config_file+=".cshrc"
fi

# edit configuration file to proxify shells
cp $config_file "$config_file.bak"
echo "export ALL_PROXY='socks5://127.0.0.1:9050'" >> $config_file
source $config_file &> /dev/null

echo "[-] Starting TOR"
systemctl start tor

while true; do
    printf "\r[*] Current IP: $(curl https://2ip.io/)"
    sleep $SLEEP_TIME
    systemctl restart tor
done

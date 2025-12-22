#!/bin/bash

####################
# file:   setup.sh #
# author: xxyrnn   #
####################

if [ ! -f /usr/sbin/tor ]; then
  case $(cat /etc/*-release | grep "DISTRIB_ID" | cut -d '"' -f 2) in
    Arch)
      sudo pacman -Sy tor
      ;;
    Debian | Ubuntu)
      sudo apt update && sudo apt install tor
      ;;
    Fedora)
      sudo dnf check-update && sudo dnf install tor
      ;;
    SUSE | RedHat)
      sudo rpm -Fi tor
      ;;
    *)
      echo "[!] Unsupported OS"
      ;;
  esac
fi

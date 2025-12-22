#!/bin/bash

######################
# file:   install.sh #
# author: xxyrnn     #
######################

pm_fallback() {
  if command -v apt >/dev/null 2>&1; then
    echo apt
  elif command -v dnf >/dev/null 2>&1; then
    echo dnf
  elif command -v pacman >/dev/null 2>&1; then
    echo pacman
  elif command -v zypper >/dev/null 2>&1; then
    echo zypper
  else
    echo "[!] Unsupported OS"
    return 1
  fi
}

detect_package_manager() {
  if [ -r /etc/os-release ]; then
    . /etc/os-release

    case $ID in
      debian|ubuntu|linuxmint)
        echo apt
        ;;
      fedora|rhel|centos|rocky|almalinux)
        echo dnf
        ;;
      arch|manjaro|endeavouros)
        echo pacman
        ;;
      opensuse*|sles)
        echo zypper
        ;;
      *)
        echo $(pm_fallback)
        ;;
    esac
  else
    echo "[!] Unsupported OS"
    return 1
  fi
}

if ! command -v tor >/dev/null 2>&1; then
  PM=$(detect_package_manager) || {
    echo "[!] Unsupported OS" >&2
    exit 1
  }

  echo "[*] Installing TOR..."

  case $PM in
    apt)
      sudo apt update && sudo apt install -y tor
      ;;
    dnf)
      sudo dnf check-update && sudo dnf install -y tor
      ;;
    pacman)
      sudo pacman -Sy --noconfirm tor
      ;;
    zypper)
      sudo zypper install -y tor
      ;;
    *)
      ;;
  esac

  echo "[*] TOR installed"
  echo "[*] Getting anonymize.sh"
  wget https://raw.githubusercontent.com/xxyrnn/anonymize/refs/heads/main/anonymize.sh
  echo "[*] Making anonymize.sh executable"
  chmod +x anonymize.sh
  echo "[*] Installation complete"
else
  echo "[*] TOR already installed"
fi

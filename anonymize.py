#!/bin/python3

import subprocess
import time
import sys
import os

if os.geteuid() != 0:
    print("[!] ERROR: this script must be run as root or sudo")
    sys.exit(1)

match os.getenv("SHELL"):
    case "/bin/bash":
        CONFIG_FILE = ".bashrc"
    case "/bin/zsh":
        CONFIG_FILE = ".zshrc"
    case "/bin/fish":
        CONFIG_FILE = ".config/fish/config.fish"
    case "/bin/ksh":
        CONFIG_FILE = ".kshrc"
    case _:
        CONFIG_FILE = ""

CONFIG_PATH = f"{os.getenv("HOME")}/{CONFIG_FILE}"

cmd = subprocess.run(["cp", CONFIG_PATH, f"{CONFIG_PATH}.bak"])

if cmd.returncode == 1:
    sys.exit("[!] ERROR: cannot find shell config file")

with open(CONFIG_PATH, "a", encoding="utf-8") as f:
    print("export ALL_PROXY='socks5://127.0.0.1:9050'", file=f) # environment variable to proxify the whole shell

# only start TOR if we can source the modified config file
cmd = subprocess.run([f"source {CONFIG_PATH}", "&&", "systemctl", "start", "tor"], shell=True)

if cmd.returncode == 0:
    print("[*] Anonymizer is running")

try:
    while True:
        # r = subprocess.run(["curl", "https://2ip.io/"], capture_output=True) # obtain current public IP
        # print("[*] Your IP is", r.stdout.decode().strip())
        time.sleep(60) # sleep 60 seconds
        subprocess.run(["systemctl", "restart", "tor"])
except KeyboardInterrupt:
    print("[-] Stopping TOR and cleaning resources...")
    subprocess.run(["systemctl", "stop", "tor"])
finally:
    os.remove(CONFIG_PATH) # remove modified config file
    subprocess.run([f"mv {CONFIG_PATH}.bak {CONFIG_PATH}", "&&", f"source {CONFIG_PATH}"], shell=True) # restore original config file

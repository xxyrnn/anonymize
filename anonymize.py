#!/bin/python3

import subprocess
import requests
import time
import sys
import os

if os.geteuid() != 0:
    print("[!] ERROR: this script must be run as root")
    sys.exit(1)

subprocess.run(["systemctl", "start", "tor"])

try:
    while True:
        #req = subprocess.run(["proxychains4", "curl", "https://2ip.io/"], capture_output=True)
        #print("[*] Your IP is", req.stdout.decode().strip())
        time.sleep(60) # sleep 60 seconds
        subprocess.run(["systemctl", "restart", "tor"])
        print("[*] TOR restarted")
except KeyboardInterrupt:
    print("[-] Stopping TOR...")
    subprocess.run(["systemctl", "stop", "tor"])

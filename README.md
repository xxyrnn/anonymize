# Anonymize

Script that uses and continuously restarts TOR as a proxy to anonymize your internet traffic.

The script creates a backup of your shell configuration file (e.g. `.bashrc`) and adds a line
to it that exports the `ALL_PROXY` system variable, which tells Linux to tunnel your shell's
traffic through that proxy. This means that every new shell that you open will be already
proxied.

> [!CAUTION]
> Only the shell will be proxied, NOTHING ELSE

> [!TIP]
> To anonymize browser traffic, you have to edit the browser's settings or use a tool/extension
> like [FoxyProxy Basic](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-basic/)

## Installation

1. Install TOR:
   ```bash
   sudo pacman -Sy tor # Arch-based
   sudo apt update && sudo apt install tor # Debian/Ubuntu-based
   sudo rpm -Fi tor # Red Hat-based
   sudo dnf check-update && sudo dnf install tor # Fedora-based
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/xxyrnn/anonymize.git
   ```

3. Make the script executable:
   ```bash
   chmod +x anonymize.sh
   ```

## Usage

Run the script:
```bash
./anonymize.sh
```

Now you can either put the script in background and keep working in the same console or just
open a new console and continue working from there

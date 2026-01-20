# Anonymize

Script that uses and continuously restarts TOR as a proxy to anonymize your internet traffic.

The script edits your shell configuration file (e.g. `.bashrc`) by adding a line
that exports the `ALL_PROXY` system variable, which tells Linux to tunnel your shell's
traffic through that proxy. This means that every new opened shell will be automatically
proxied.

> [!CAUTION]
> Only the shell will be proxied, NOTHING ELSE

> [!TIP]
> To anonymize browser traffic, you have to edit the browser's settings or use a tool/extension
> like [FoxyProxy Basic](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-basic/)

## Installation

1. Download `install.sh` from the [latest release](https://github.com/xxyrnn/anonymize/releases/latest)
2. Make the installation script executable
    ```bash
    chmod +x install.sh
    ```
3. Run the installation script
    ```bash
    ./install.sh
    ```

## Usage

Run the script:
```bash
sudo ./anonymize.sh
```

Now you can either put the script in background and keep working in the same console or just
open a new console and continue working from there.

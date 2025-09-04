# DevOps Tools Installer

This Bash script automates the installation of essential DevOps tools on Ubuntu/Debian:

- Docker
- Docker Compose
- Python 3.9+
- Django (via pip)

## Features

- Checks if tools are already installed to avoid duplicates
- Installs missing tools with recommended methods
- Designed to run with sudo on Ubuntu/Debian

## Usage

Make executable:

```
chmod u+x install_dev_tools.sh
```

Run:

```
sudo ./install_dev_tools.sh
```

After installation, log out and log back in or run:

```
newgrp docker
```

to apply Docker permissions.

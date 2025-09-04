#!/bin/bash

# Check if the script is running on Ubuntu or Debian
check_os() {
  if ! grep -Ei 'ubuntu|debian' /etc/os-release > /dev/null; then
    echo "This script is intended for Ubuntu or Debian systems."
    exit 1
  fi
}

# Check if the script is run as root or with sudo
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run the script as root or with sudo privileges."
    exit 1
  fi
}

# Update package index and install prerequisite packages
update_system() {
  echo "Updating package list..."
  apt update -y
  apt install -y software-properties-common curl
}

# Install Docker if missing
install_docker() {
  if command -v docker &> /dev/null; then
    local version=$(docker --version | awk '{print $3}' | sed 's/,//')
    echo "Docker is already installed (version: $version)."
  else
    echo "Installing Docker..."
    apt install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker $SUDO_USER
    echo "Docker installed successfully."
  fi
}

# Install Docker Compose if missing
install_docker_compose() {
  if command -v docker-compose &> /dev/null; then
    local version=$(docker-compose --version | awk '{print $3}' | sed 's/,//')
    echo "Docker Compose is already installed (version: $version)."
  else
    echo "Installing Docker Compose..."
    apt install -y docker-compose
    echo "Docker Compose installed successfully."
  fi
}

# Check if version1 >= version2
version_ge() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# Install Python 3.9+ if needed
install_python() {
  local REQUIRED_VERSION="3.9"
  local current_version=""

  if command -v python3 &> /dev/null; then
    current_version=$(python3 -V 2>&1 | awk '{print $2}')
  fi

  if [ -n "$current_version" ] && version_ge "$current_version" "$REQUIRED_VERSION"; then
    echo "Python $current_version is already installed."
  else
    echo "Installing Python 3.9..."
    add-apt-repository -y ppa:deadsnakes/ppa
    apt update -y
    apt install -y python3.9 python3.9-venv python3.9-distutils
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
    echo "Python 3.9 installed successfully."
  fi
}

# Install pip3 if missing
install_pip() {
  if command -v pip3 &> /dev/null; then
    echo "pip is already installed."
  else
    echo "Installing pip..."
    apt install -y python3-pip
    echo "pip installed successfully."
  fi
}

# Install Django via pip if missing
install_django() {
  if python3 -c "import django" &> /dev/null; then
    local version=$(python3 -c "import django; print(django.get_version())")
    echo "Django is already installed (version: $version)."
  else
    echo "Installing Django..."
    python3 -m pip install --user django
    echo "Django installed successfully."
    echo "Please make sure ~/.local/bin is in your PATH environment variable."
  fi
}

# Show versions of installed tools
show_versions() {
  echo ""
  echo "Installed tool versions:"
  docker --version
  docker-compose --version
  python3 --version
  python3 -c "import django; print('Django', django.get_version())"
  echo ""
}

main() {
  check_os
  check_root

  echo "Starting DevOps tools installation..."

  update_system
  install_docker
  install_docker_compose
  install_python
  install_pip
  install_django

  show_versions

  echo "Installation completed!"
  echo "If this is your first time installing Docker, please log out and log back in to apply Docker group permissions."
  echo "Or use the command: newgrp docker"
}

main "$@"
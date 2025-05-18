#!/bin/bash

set -e

# Absolute path to package download location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/../packages"

mkdir -p "$PKG_DIR"

# Detect OS version
OS_VERSION=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))
USE_DNF=false

if [[ "$OS_VERSION" -ge 9 ]]; then
    USE_DNF=true
fi

echo "Detected CentOS/RHEL Version: $OS_VERSION"
echo "Using: $([[ $USE_DNF == true ]] && echo 'dnf' || echo 'yum')"

# Ensure package downloader is installed
if [[ "$USE_DNF" == true ]]; then
    sudo dnf install -y dnf-utils dnf-plugins-core
else
    sudo yum install -y yum-utils || sudo yum localinstall -y "$PKG_DIR"/yum-utils-*.rpm
fi

# Lightweight C/C++ development tools
DEV_PACKAGES=(
    gcc gcc-c++ glibc-devel make cmake git
    wget curl unzip tar
    zlib-devel openssl-devel ncurses-devel
    libffi-devel libuuid-devel libxml2-devel
    libcurl-devel readline-devel bzip2-devel
    sqlite-devel xz-devel gmp-devel mpfr-devel
    libmpc-devel autoconf automake libtool
)

echo "Downloading development RPMs into $PKG_DIR ..."

# Loop through and download each package with dependencies
for pkg in "${DEV_PACKAGES[@]}"; do
    if [[ "$USE_DNF" == true ]]; then
        dnf download --alldeps --resolve --destdir="$PKG_DIR" "$pkg"
    else
        yumdownloader --resolve --destdir="$PKG_DIR" "$pkg"
    fi
done

echo "✅ All required packages downloaded into: $PKG_DIR"


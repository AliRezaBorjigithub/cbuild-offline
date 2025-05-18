#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/../packages"

if [ ! -d "$PKG_DIR" ]; then
    echo "❌ Package directory not found: $PKG_DIR"
    exit 1
fi

echo "📦 Installing RPMs from: $PKG_DIR"

if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y "$PKG_DIR"/*.rpm
elif command -v yum >/dev/null 2>&1; then
    sudo yum localinstall -y "$PKG_DIR"/*.rpm
else
    echo "❌ Neither dnf nor yum is available. Cannot install packages."
    exit 1
fi

echo "✅ Installation complete."


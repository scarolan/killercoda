#!/bin/bash
set -euxo pipefail  # Exit immediately if any command fails

# ------------------------------------------------------------------------------
# Grafana Alloy VS Code Extension Installer for Killercoda
# Installs syntax highlighting and language support for .alloy files in Theia.
# ------------------------------------------------------------------------------

# Define the download URL and version
VSIX_URL="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
VSIX_NAME="grafana-alloy-0.2.0.vsix"
EXT_NAME="grafana-alloy-0.2.0"

# Define the directory where Theia loads its extensions
EXT_DIR="$HOME/.theia/extensions"

# Create the extensions directory if it doesn't exist
mkdir -p "$EXT_DIR"
cd "$EXT_DIR"

echo "🔧 Downloading Grafana Alloy VSIX package..."
# Download the .vsix file quietly (-s) and follow redirects (-L)
curl -sLO "$VSIX_URL"

echo "📦 Unpacking the VSIX into a Theia-compatible folder..."
# Unzip the VSIX into a folder named after the extension
mkdir -p "$EXT_NAME"
unzip -q "$VSIX_NAME" -d "$EXT_NAME"

echo "🧹 Cleaning up..."
# Remove the VSIX after unpacking
rm "$VSIX_NAME"

echo "✅ Grafana Alloy extension installed at: $EXT_DIR/$EXT_NAME"

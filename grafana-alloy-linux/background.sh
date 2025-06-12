#!/bin/bash
set -euxo pipefail  # Exit on error, show commands

# Enable fancy prompt
wget -O ~/.fancy-prompt.sh https://raw.githubusercontent.com/scarolan/fancy-linux-prompt/master/fancy-prompt.sh
echo "source ~/.fancy-prompt.sh" >> ~/.bashrc

# Download Grafana Alloy VSIX to current directory
VSIX_URL="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
VSIX_NAME="grafana-alloy-0.2.0.vsix"

# Download the VSIX file using wget
wget -q "$VSIX_URL" -O "$VSIX_NAME"

echo "✅ Downloaded $VSIX_NAME to $(pwd)"

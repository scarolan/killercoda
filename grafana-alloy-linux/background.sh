#!/bin/bash
set -euxo pipefail  # Exit on error, show commands

# Update apt and install necessary packages
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
apt -y update

# Enable fancy prompt
wget -O ~/.fancy-prompt.sh https://raw.githubusercontent.com/scarolan/fancy-linux-prompt/master/fancy-prompt.sh
echo "source ~/.fancy-prompt.sh" >> ~/.bashrc

# Download Grafana Alloy VSIX to current directory
VSIX_URL="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
VSIX_NAME="grafana-alloy-0.2.0.vsix"

# Download the VSIX file using wget
wget -q "$VSIX_URL" -O "$VSIX_NAME"

echo "✅ Downloaded $VSIX_NAME to $(pwd)"

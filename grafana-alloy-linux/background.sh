#!/bin/bash
set -euxo pipefail  # Exit immediately if any command fails

# ------------------------------------------------------------------------------
# Install Grafana Alloy VSIX into Theia
# ------------------------------------------------------------------------------

VSIX_URL="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
VSIX_NAME="grafana-alloy-0.2.0.vsix"
EXT_DIR="$HOME/.theia/extensions/grafana-alloy-0.2.0.vsix"

# Download and unzip to match the UI install path
mkdir -p "$EXT_DIR"
cd /tmp
curl -sLO "$VSIX_URL"

echo "📦 Unzipping VSIX to $EXT_DIR..."
unzip -q "$VSIX_NAME" -d "$EXT_DIR"

rm "$VSIX_NAME"

echo "✅ Extension installed to $EXT_DIR"
echo "🔁 Reload Theia to activate it (Ctrl+Shift+P → Reload Window)."
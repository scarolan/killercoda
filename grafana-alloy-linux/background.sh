#!/bin/bash
set -euxo pipefail  # Exit immediately if any command fails

# ------------------------------------------------------------------------------
# Install Grafana Alloy VSIX into Theia
# ------------------------------------------------------------------------------

VSIX_URL="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
EXTENSIONS_DIR="$HOME/.theia/extensions"
INSTALL_DIR="$EXTENSIONS_DIR/grafana-alloy-0.2.0.vsix"  # ← key trick: .vsix folder suffix

mkdir -p "$INSTALL_DIR"
cd /tmp

echo "📥 Downloading Grafana Alloy VSIX..."
curl -sLO "$VSIX_URL"

echo "📦 Extracting entire VSIX (including metadata)..."
unzip -q grafana-alloy-0.2.0.vsix -d "$INSTALL_DIR"
rm grafana-alloy-0.2.0.vsix

echo "✅ Installed at $INSTALL_DIR"
echo "🔁 Reload Theia to activate it (Ctrl+Shift+P → Reload Window)."
#!/bin/bash
set -euxo pipefail  # Exit on error, show commands

# Update apt and install necessary packages
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
apt -y update

# Enable fancy prompt
wget -O ~/.fancy-prompt.sh https://raw.githubusercontent.com/scarolan/fancy-linux-prompt/master/fancy-prompt.sh
cat <<'EOF' >> ~/.bashrc

# -----------------------------------------------------------------------------
# Set prompt based on terminal capabilities
# If running inside Killercoda's Theia terminal (TERM=xterm-color),
# fall back to a simpler ASCII prompt with basic colors to avoid font issues.
# Otherwise, source a fancy Powerline-style prompt from ~/.fancy-prompt.sh
# -----------------------------------------------------------------------------
if [[ "\$TERM" == "xterm-color" ]]; then
  export PS1="\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] \$ "
else
  source ~/.fancy-prompt.sh
fi
EOF

# Download Grafana Alloy VSIX to current directory
VSIX_URL="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
VSIX_NAME="grafana-alloy-0.2.0.vsix"

# Download the VSIX file using wget
wget -q "$VSIX_URL" -O "$VSIX_NAME"
echo "✅ Downloaded $VSIX_NAME to $(pwd)"


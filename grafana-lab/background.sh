#!/bin/bash
set -euo pipefail  # Exit on error, show commands

# Update apt and install necessary packages
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
apt -y update

# Install Grafana and Alloy
apt -y install grafana alloy btop

# Fix the Alloy config so Killercoda can reach it
sudo sed -i -e '/^CUSTOM_ARGS=/s#".*"#"--server.http.listen-addr=0.0.0.0:12345"#' /etc/default/alloy

# Define a list of VSIX files to download
declare -A VSIX_FILES=(
  ["grafana-alloy-0.2.0.vsix"]="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
  ["dracula-theme.theme-dracula-2.25.1.vsix"]="https://open-vsx.org/api/dracula-theme/theme-dracula/2.25.1/file/dracula-theme.theme-dracula-2.25.1.vsix"
  ["jdinhlife.gruvbox-1.28.0.vsix"]="https://open-vsx.org/api/jdinhlife/gruvbox/1.28.0/file/jdinhlife.gruvbox-1.28.0.vsix"
)

# Create downloads directory and Theia extensions directory
mkdir -p downloads
mkdir -p ~/.theia/extensions

# Download each VSIX file
for vsix_name in "${!VSIX_FILES[@]}"; do
  vsix_url="${VSIX_FILES[$vsix_name]}"
  wget -q "$vsix_url" -O "downloads/$vsix_name"
  echo "✅ Downloaded $vsix_name to $(pwd)/downloads"
done

# Move to downloads directory and unzip each VSIX file into the extensions directory
cd downloads
for vsix_file in *.vsix; do
  dir_name="${vsix_file%.vsix}"
  echo "Unzipping $vsix_file into ~/.theia/extensions/$dir_name/"
  unzip -q "$vsix_file" -d ~/.theia/extensions/"$dir_name"
done
cd ..

# Function to restart the Theia process in the /root/workspace directory
restart_theia() {
  echo "Looking for Theia process..."
  local theia_pid=$(pgrep -f "/opt/theia/node /opt/theia/browser-app/src-gen/backend/main.js")

  if [ -n "$theia_pid" ]; then
    echo "Killing Theia process with PID $theia_pid"
    kill -9 "$theia_pid"
    sleep 2
  else
    echo "No Theia process found to kill"
  fi

  echo "Starting Theia process in the background..."
  nohup /opt/theia/node /opt/theia/browser-app/src-gen/backend/main.js /root --hostname=0.0.0.0 --port 40205 > /dev/null 2>&1 &
  echo "Theia restarted with PID $!"
}

# Restart Theia to apply changes
restart_theia

# Install the Grafana Alloy vim plugin
mkdir -p ~/.vim/pack/plugins/start && git clone https://github.com/grafana/vim-alloy ~/.vim/pack/plugins/start/vim-alloy

# Enable fancy prompt
wget -O ~/.fancy-prompt.sh https://raw.githubusercontent.com/scarolan/fancy-linux-prompt/master/fancy-prompt.sh
cat <<'EOF' >> ~/.bashrc

# -----------------------------------------------------------------------------
# Set prompt based on terminal capabilities
# If running inside Killercoda's Theia terminal (TERM=xterm-color),
# fall back to a simpler ASCII prompt with basic colors to avoid font issues.
# Otherwise, source a fancy Powerline-style prompt from ~/.fancy-prompt.sh
# -----------------------------------------------------------------------------
if [[ "$TERM" == "xterm-color" ]]; then
  export PS1="\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] \$ "
else
  source ~/.fancy-prompt.sh
fi

# Set locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# setup-complete
EOF

#!/bin/bash
set -euo pipefail  # Exit on error, show commands

# Create downloads directory and Theia extensions directory
mkdir -p downloads
mkdir -p ~/.theia/extensions

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
  ["redhat.vscode-yaml-1.9.1.vsix"]="https://open-vsx.org/api/redhat/vscode-yaml/1.9.1/file/redhat.vscode-yaml-1.9.1.vsix"
)

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

# Function to restart the Theia process
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
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/grafana/vim-alloy ~/.vim/pack/plugins/start/vim-alloy

# Install Vim colorschemes
mkdir -p ~/.vim/pack/colors/start
git clone https://github.com/morhetz/gruvbox ~/.vim/pack/colors/start/gruvbox
git clone https://github.com/dracula/vim.git ~/.vim/pack/colors/start/dracula
git clone https://github.com/sainnhe/everforest.git ~/.vim/pack/colors/start/everforest

# Set the Vim colorscheme to everforest
echo "colorscheme everforest" >> ~/.vimrc

# Provision data sources in Grafana
mkdir -p /etc/grafana/provisioning/datasources

# Configure Grafana admin password
cat <<EOF > /etc/grafana/grafana.ini
[security]
admin_user = admin
admin_password = grafana

[plugins]
allow_loading_unsigned_plugins = grafana-testdata-datasource
EOF

# Create TestData datasource for the workshop
cat <<EOF > /etc/grafana/provisioning/datasources/testdata.yaml
apiVersion: 1
datasources:
  - name: TestData
    type: grafana-testdata-datasource
    access: proxy
    isDefault: true
    editable: true
    uid: PD8C576611E62080A
EOF

# Add Prometheus data source as backup
cat <<EOF > /etc/grafana/provisioning/datasources/prometheus.yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: false
    editable: true
EOF

# Create necessary folders for dashboards
mkdir -p /etc/grafana/provisioning/dashboards
mkdir -p /var/lib/grafana/dashboards

# Download the dashboard JSON for the workshop
mkdir -p /var/lib/grafana/dashboards
wget -q -O /var/lib/grafana/dashboards/home-dashboard.json https://raw.githubusercontent.com/scarolan/killercoda/refs/heads/main/grafana-dashboarding/dashboards/home-dashboard.json

# Create a provisioning file for the home dashboard
cat <<EOF > /etc/grafana/provisioning/dashboards/home-dashboard.yaml
apiVersion: 1
providers:
  - name: 'Overcharge SRE Dashboard - Original'
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
      foldersFromFilesStructure: true
EOF

# Configure home dashboard and other Grafana preferences
cat <<EOF >> /etc/grafana/grafana.ini
[dashboards]
default_home_dashboard_path = /var/lib/grafana/dashboards/home-dashboard.json
EOF

# Restart Grafana server to apply changes
systemctl restart grafana-server

# Wait for Grafana server to be ready
until curl -sSf http://localhost:3000/api/health > /dev/null; do
  echo "Waiting for Grafana to be ready..."
  sleep 2
done
echo "Grafana is ready."

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

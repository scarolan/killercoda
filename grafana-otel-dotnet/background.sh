#!/bin/bash
set -euo pipefail  # Exit on error, show commands

# Create downloads directory and Theia extensions directory
mkdir -p downloads
mkdir -p ~/.theia/extensions

# Update apt and install necessary packages
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list

# Install Microsoft package repository for .NET Core
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Update apt package lists
apt -y update

# Install Alloy, dotnet SDK, and btop
apt -y install alloy btop dotnet-sdk-8.0 aspnetcore-runtime-8.0 redis

# Fix the Alloy config so Killercoda can reach it
sudo sed -i -e '/^CUSTOM_ARGS=/s#".*"#"--server.http.listen-addr=0.0.0.0:12345"#' /etc/default/alloy

# Define a list of VSIX files to download
declare -A VSIX_FILES=(
  ["grafana-alloy-0.2.0.vsix"]="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
  ["dracula-theme.theme-dracula-2.25.1.vsix"]="https://open-vsx.org/api/dracula-theme/theme-dracula/2.25.1/file/dracula-theme.theme-dracula-2.25.1.vsix"
  ["jdinhlife.gruvbox-1.28.0.vsix"]="https://open-vsx.org/api/jdinhlife/gruvbox/1.28.0/file/jdinhlife.gruvbox-1.28.0.vsix"
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

# Restart Alloy
systemctl restart alloy

# Clone the Grafana OpenTelemetry .NET repository
echo "Cloning the Grafana OpenTelemetry .NET repository..."
git clone https://github.com/grafana/grafana-opentelemetry-dotnet.git

# Fix the version of the SDK
perl -pi -e 's/"version"\s*:\s*"[0-9.]+"/"version": "8.0.117"/' ~/grafana-opentelemetry-dotnet/global.json

# Create a symlink for easy access
ln -s ~/grafana-opentelemetry-dotnet/examples/net8.0/aspnetcore ~/TodoApp
cd TodoApp
dotnet add package Microsoft.Extensions.Caching.StackExchangeRedis
dotnet add package AWSSDK.S3 --version 3.7.400
dotnet add package Microsoft.Data.SqlClient

# Build to ensure all dependencies are resolved
echo "Restoring dependencies and building app..."
dotnet restore

# Create a startup script for the app with environment variables
cat > ~/start-app.sh << 'EOL'
#!/bin/bash
set -e

echo "Starting ASP.NET Core Todo API with Grafana OpenTelemetry instrumentation..."
echo ""
echo "Environment configuration:"
echo "- OTEL_SERVICE_NAME=dotnet-todoapi"
echo "- OTEL_RESOURCE_ATTRIBUTES=deployment.environment=production"
echo "- OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317"
echo "- OTEL_EXPORTER_OTLP_PROTOCOL=grpc"
echo ""

export OTEL_SERVICE_NAME=dotnet-todoapi
export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=production
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export ASPNETCORE_URLS=http://0.0.0.0:8080

cd ~/TodoApp
dotnet run
EOL

chmod +x ./start-app.sh

# Verify that everything is in place
echo "Verifying the project setup..."
if [ -f Program.cs ] && [ -f TodoApi.csproj ]; then
    echo "✅ TodoApi setup complete and ready to run"
else
    echo "⚠️ Warning: Some project files may be missing"
fi

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
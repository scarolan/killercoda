#!/bin/bash
set -euo pipefail  # Exit on error, show commands

# Create downloads directory and Theia extensions directory
mkdir -p downloads
mkdir -p ~/.theia/extensions
mkdir -p ~/dotnet-app

# Check for our local Program.cs file location
if [ -f "/root/scenario/TodoApi-Program.cs" ]; then
  cp /root/scenario/TodoApi-Program.cs /root/
elif [ -f "/mnt/scenario/TodoApi-Program.cs" ]; then
  cp /mnt/scenario/TodoApi-Program.cs /root/
else
  echo "Note: Fallback Program.cs file not found in standard locations"
fi

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
apt -y install alloy btop dotnet-sdk-8.0 aspnetcore-runtime-8.0

# Fix the Alloy config so Killercoda can reach it
sudo sed -i -e '/^CUSTOM_ARGS=/s#".*"#"--server.http.listen-addr=0.0.0.0:12345"#' /etc/default/alloy

# Define a list of VSIX files to download
declare -A VSIX_FILES=(
  ["grafana-alloy-0.2.0.vsix"]="https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix"
  ["dracula-theme.theme-dracula-2.25.1.vsix"]="https://open-vsx.org/api/dracula-theme/theme-dracula/2.25.1/file/dracula-theme.theme-dracula-2.25.1.vsix"
  ["jdinhlife.gruvbox-1.28.0.vsix"]="https://open-vsx.org/api/jdinhlife/gruvbox/1.28.0/file/jdinhlife.gruvbox-1.28.0.vsix",
  ["muhammad-sammy.csharp-2.80.16.vsix"]="https://open-vsx.org/api/muhammad-sammy/csharp/2.80.16/file/muhammad-sammy.csharp-2.80.16.vsix"
)

# Download each VSIX file
for vsix_name in "${!VSIX_FILES[@]}"; do
  vsix_url="${VSIX_FILES[$vsix_name]}"
  echo "Downloading $vsix_name..."
  if wget -q --show-progress "$vsix_url" -O "downloads/$vsix_name"; then
    echo "✅ Downloaded $vsix_name to $(pwd)/downloads"
    # Verify file integrity
    if file "downloads/$vsix_name" | grep -q "Zip archive data"; then
      echo "✅ File appears to be a valid zip archive"
    else
      echo "⚠️ Warning: $vsix_name does not appear to be a valid zip archive"
    fi
  else
    echo "⚠️ Failed to download $vsix_name"
  fi
done

# Move to downloads directory and unzip each VSIX file into the extensions directory
cd downloads
for vsix_file in *.vsix; do
  dir_name="${vsix_file%.vsix}"
  mkdir -p ~/.theia/extensions/"$dir_name"
  echo "Unzipping $vsix_file into ~/.theia/extensions/$dir_name/"
  
  # Try to verify if it's a valid zip file first
  if zipinfo -1 "$vsix_file" &>/dev/null; then
    if unzip -q "$vsix_file" -d ~/.theia/extensions/"$dir_name"; then
      echo "✅ Successfully unzipped $vsix_file"
    else
      echo "⚠️ Failed to unzip $vsix_file - continuing with next extension"
    fi
  else
    echo "⚠️ $vsix_file is not a valid zip file - skipping"
  fi
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

# Create a new dotnet webapi project
cd ~/dotnet-app
dotnet new webapi -n TodoApi
cd TodoApi

# Add required packages
dotnet add package Grafana.OpenTelemetry --version 1.2.0
dotnet add package OpenTelemetry.Extensions.Hosting --version 1.6.0
dotnet add package OpenTelemetry.Exporter.Console --version 1.6.0
dotnet add package Microsoft.EntityFrameworkCore.InMemory
dotnet add package System.Diagnostics.DiagnosticSource

# Download the Program.cs file with OpenTelemetry instrumentation from GitHub
echo "Downloading Program.cs from GitHub..."
wget -O ~/dotnet-app/TodoApi/Program.cs https://raw.githubusercontent.com/grafana/grafana-opentelemetry-dotnet/main/examples/net8.0/aspnetcore/Program.cs

# Check if the download was successful (file exists and has content)
if [ ! -s ~/dotnet-app/TodoApi/Program.cs ]; then
    echo "Failed to download Program.cs from GitHub, using local fallback..."
    # Copy our local fallback file
    cp /root/TodoApi-Program.cs ~/dotnet-app/TodoApi/Program.cs
fi

# Create a startup script for the app with environment variables
cat > ~/dotnet-app/TodoApi/start-app.sh << 'EOL'
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

cd ~/dotnet-app/TodoApi
dotnet run
EOL

chmod +x ~/dotnet-app/TodoApi/start-app.sh

# Build the app
cd ~/dotnet-app/TodoApi
dotnet build

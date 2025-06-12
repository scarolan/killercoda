FROM ubuntu:22.04

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install core packages and setup Grafana repo
RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg git bash \
 && mkdir -p /etc/apt/keyrings/ \
 && wget -qO - https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list \
 && apt-get update \
 && apt-get clean

# Download and stage the Alloy VSIX
RUN wget -q https://github.com/grafana/vscode-alloy/releases/download/v0.2.0/grafana-alloy-0.2.0.vsix -O /opt/grafana-alloy.vsix

# Add the fancy prompt
RUN wget -q -O /root/.fancy-prompt.sh https://raw.githubusercontent.com/scarolan/fancy-linux-prompt/master/fancy-prompt.sh

# Bash config
RUN cat <<'EOF' >> /root/.bashrc

# Prompt config: simplified for Theia terminal, fancy elsewhere
if [[ "\$TERM" == "xterm-color" ]]; then
  export PS1="\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] \$ "
else
  source ~/.fancy-prompt.sh
fi
EOF

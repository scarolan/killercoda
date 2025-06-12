#!/bin/bash
set -euo pipefail  # Exit on error, show commands

# This script runs after the background script completes.
if [[ "\$TERM" == "xterm-color" ]]; then
  export PS1="\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] \$ "
else
  source ~/.fancy-prompt.sh
fi
echo "Hello world!"
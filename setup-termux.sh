#!/bin/bash
# ==========================================
# LinkedIn Automation Sovereignty Kit — Termux Setup
# ==========================================
# Works on: Termux (Android 7+), also compatible with Hermes Desktop
# Author: binitkalsara (open source, free to modify)
# ==========================================

set -e

echo "=========================================="
echo "LinkedIn Automation Sovereignty Kit"
echo "Termux Setup — One-Click"
echo "=========================================="
echo

# 1. Update Termux packages
echo "[1/6] Updating Termux packages..."
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1

# 2. Install dependencies
echo "[2/6] Installing python, git, curl..."
pkg install -y python git curl > /dev/null 2>&1

# 3. Clone this repo if not already
REPO_DIR="$HOME/linkedin-automation-kit"
if [ ! -d "$REPO_DIR" ]; then
    echo "[3/6] Cloning repository..."
    git clone https://github.com/binitkalsara/linkedin-automation-kit "$REPO_DIR" > /dev/null 2>&1
else
    echo "[3/6] Repository already present — pulling latest..."
    cd "$REPO_DIR" && git pull > /dev/null 2>&1
fi
cd "$REPO_DIR"

# 4. Make scripts executable
echo "[4/6] Making scripts executable..."
chmod +x linkedin-daily-enrich.sh check-blocking.py alert-telegram.sh setup-termux.sh 2>/dev/null

# 5. Create storage permission and_dir
echo "[5/6] Setting up Termux storage access..."
termux-setup-storage > /dev/null 2>&1
sleep 2

# 6. Final verification
echo "[6/6] Verifying setup..."
echo
python3 -c "import bs4; print('beautifulsoup4: OK')" 2>/dev/null || pip install beautifulsoup4 > /dev/null 2>&1
python3 -c "import requests; print('requests: OK')" 2>/dev/null || pip install requests > /dev/null 2>&1

echo
echo "=========================================="
echo "Setup Complete! 🎉"
echo "=========================================="
echo
echo "Next steps:"
echo "1. Open Termux and run: cd $REPO_DIR"
echo "2. Run: bash linkedin-daily-enrich.sh"
echo "3. Follow prompts (enter your Telegram bot token when asked)"
echo
echo "Need help? Read: $REPO_DIR/README.md"
echo

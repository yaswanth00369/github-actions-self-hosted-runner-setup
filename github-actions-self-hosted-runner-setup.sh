#!/bin/bash
set -e

# -------- CONFIGURABLE VARIABLES --------
GITHUB_ORG="YaswanthCICD"             # <-- Replace this
REG_TOKEN="AYCUCOEHVGUW2BTEUIF2U2DIO7CCU"    # <-- Generate from GitHub Org → Settings → Actions → Runners → Add runner
RUNNER_NAME="Dev-Runner"  # Optional custom runner name
RUNNER_LABELS="Dev-Runner"  # Optional custom runner labels

# -------- OS DETECTION & PACKAGE INSTALLATION --------
if grep -qi "amazon\|rhel\|red hat\|centos\|fedora" /etc/os-release; then
  echo "🟡 Amazon/CentOS/Fedora/RedHat system detected. Installing required packages..."
  sudo yum upgrade -y
  sudo yum install -y curl jq tar dotnet-sdk-8.0
elif grep -qi "ubuntu\|debian" /etc/os-release; then
  echo "🟢 Ubuntu/Debian system detected. Installing required packages..."
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y curl jq tar dotnet-sdk-8.0
else
  echo "❌ Unsupported OS detected. Exiting."
  exit 1
fi

# -------- CREATE RUNNER DIRECTORY --------
mkdir -p ~/actions-runner && cd ~/actions-runner

# -------- DOWNLOAD LATEST RUNNER PACKAGE --------
LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')
RUNNER_VERSION="${LATEST_VERSION#v}"
RUNNER_URL="https://github.com/actions/runner/releases/download/${LATEST_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

echo "📦 Downloading GitHub Actions runner version ${LATEST_VERSION}..."
curl -o actions-runner-linux-x64.tar.gz -L "$RUNNER_URL"
tar xzf actions-runner-linux-x64.tar.gz

# -------- CONFIGURE RUNNER --------
echo "⚙️ Configuring runner for org: $GITHUB_ORG"
./config.sh \
  --url "https://github.com/${GITHUB_ORG}" \
  --token "$REG_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --unattended

# -------- INSTALL & START AS SYSTEM SERVICE --------
echo "🚀 Installing and starting runner as a systemd service..."
sudo ./svc.sh install
sudo ./svc.sh start

echo "✅ GitHub Actions runner installed and running for organization: $GITHUB_ORG"

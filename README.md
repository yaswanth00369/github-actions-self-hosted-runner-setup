# 🚀 GitHub Actions Self-Hosted Runner Setup Script

This repo provides a portable, OS-aware Bash script to install and configure a **self-hosted GitHub Actions runner** on any Linux machine.

---

## 🔧 What It Does

✅ Detects your OS (Debian-based or RHEL-based)  
✅ Installs required dependencies (`curl`, `tar`, `jq`, `git`, `dotnet-sdk-8.0`)  
✅ Downloads the latest GitHub Actions runner  
✅ Registers it to your **GitHub organization**  
✅ Sets up and starts the runner as a **systemd service**  
✅ Allows you to configure the runner name and labels easily

---

## ✍️ Before You Run

Update the following 4 variables at the **top of the script**:

```bash
# -------- CONFIGURABLE VARIABLES --------
GITHUB_ORG=""           # <-- Your GitHub Organization name
REG_TOKEN=""            # <-- Registration token from GitHub → Settings → Actions → Runners → New runner
RUNNER_NAME=""          # <-- Desired runner name
RUNNER_LABELS=""        # <-- Labels to use in workflows
```

---

## 🔐 How to Generate Registration Token

You can generate the registration token from:  
`GitHub → Your Org → Settings → Actions → Runners → New self-hosted runner → Linux`

---

## 🧪 How to Use

Clone this repo or download the script file and run the script file

```bash
git clone https://github.com/yaswanth00369/github-actions-self-hosted-runner-setup.git
cd github-actions-self-hosted-runner-setup

chmod +x github-actions-self-hosted-runner-setup.sh
./github-actions-self-hosted-runner-setup.sh
```
---

## 📦 Example Workflow to Use This Runner

```yaml
jobs:
  build:
    runs-on: [self-hosted, Dev-Runner]
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run Job
        run: echo "Running on Dev-Runner"
```

---

## 🧹 How to Remove the Runner

If you ever want to remove the self-hosted runner from your system, follow these steps:

### 1. Stop the runner service

```bash
sudo ~/actions-runner/svc.sh stop
```

### 2. Uninstall the runner service

```bash
sudo ~/actions-runner/svc.sh uninstall
```

### 3. Remove the runner configuration from GitHub

```bash
sudo ~/actions-runner/config.sh remove --token <YOUR_REGISTRATION_TOKEN>
```
🔐 You can regenerate the token from:
GitHub → Org → Settings → Actions → Runners → New self-hosted runner → Linux



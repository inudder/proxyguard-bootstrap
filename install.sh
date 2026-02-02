#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/proxyguard"
REPO="git@github.com:inudder/proxyguard-panel-ai-studio.git"
BRANCH="main"

[ "$EUID" -ne 0 ] && { echo "run as root"; exit 1; }

apt-get update -qq
apt-get install -y git curl ca-certificates

if [ -d "$APP_DIR/.git" ]; then
  cd "$APP_DIR"
  git fetch origin
  git reset --hard origin/$BRANCH
  git clean -fd
else
  git clone -b "$BRANCH" "$REPO" "$APP_DIR"
fi

cd "$APP_DIR"
# Pass /dev/tty to deploy.sh so read prompts work when called via pipe (curl | bash)
bash deploy.sh </dev/tty

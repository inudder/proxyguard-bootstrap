#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/proxyguard"
REPO="git@github.com:inudder/proxyguard-panel-ai-studio.git"
BRANCH="main"

# root check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Запусти через sudo"
  exit 1
fi

echo ">>> Проверка SSH доступа к GitHub..."
if ! ssh -T git@github.com >/dev/null 2>&1; then
  echo "❌ SSH доступ к GitHub не работает"
  echo "Проверь ~/.ssh/config и ключи"
  exit 1
fi

echo ">>> Установка зависимостей..."
apt-get update -qq
apt-get install -y git

if [ -d "$APP_DIR/.git" ]; then
  echo ">>> Обновление..."
  cd "$APP_DIR"
  git fetch origin
  git reset --hard origin/$BRANCH
  git clean -fd
else
  echo ">>> Клонирование..."
  git clone -b "$BRANCH" "$REPO" "$APP_DIR"
fi

cd "$APP_DIR"

echo ">>> Запуск deploy.sh..."
bash deploy.sh

echo "✅ Готово"

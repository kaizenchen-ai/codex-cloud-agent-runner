#!/usr/bin/env bash
# Codex 雲端智慧體極速初始化腳本 (備用)
set -e

echo "=== [1/4] 更新系統基礎工具 ==="
apt-get update -qy && apt-get install -qy curl git ca-certificates

echo "=== [2/4] 安裝極速 Python 管理工具 uv ==="
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.local/bin/env || export PATH="$HOME/.local/bin:$PATH"
fi
uv --version

echo "=== [3/4] 建立專屬獨立工作環境 ==="
mkdir -p /root/workspace
cd /root/workspace
uv venv .venv
source .venv/bin/activate

echo "=== [4/4] 安裝常用 AI 代理與工具套件 ==="
uv pip install requests pydantic httpx websocket-client

echo "=========================================="
echo "✅ 雲端智慧體環境已就緒！"
echo "• 工作目錄: /root/workspace"
echo "• Python 環境: 已啟動 .venv (使用 uv)"
echo "=========================================="

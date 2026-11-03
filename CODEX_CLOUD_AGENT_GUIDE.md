# Codex 雲端智慧體（Cloud Agent）初始化與備用環境指南

> **建立日期**：2026-11-03  
> **適用環境**：Codex Cloud Agent / Linux 隔離容器  
> **用途說明**：備用腳本與設定指南，供需要離線背景跑長任務時一鍵配置。

---

## 一、 核心設計原則

1. **極速啟動**：使用 `uv` 取代傳統 `pip`，套件安裝與虛擬環境建置秒級完成。
2. **無狀態拋棄**：容器關閉或重啟不心疼，所有成果自動推回 Google Drive。
3. **安全隔離**：不寫死任何敏感 API 金鑰於公開版本控制。

---

## 二、 一鍵初始化腳本 (`setup_cloud_agent.sh`)

在 Codex 雲端終端機中，直接貼上並執行：

```bash
#!/usr/bin/env bash
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
```

---

## 三、 若需在雲端安裝 Hermes Agent

在終端機中執行：

```bash
# 1. 啟動環境
cd /root/workspace
source .venv/bin/activate

# 2. 安裝 Hermes Agent
uv pip install hermes-agent

# 3. 匯入 API 金鑰 (臨時生效)
export OPENAI_API_KEY="您的金鑰"
# export GEMINI_API_KEY="您的金鑰"
# export DEEPSEEK_API_KEY="您的金鑰"

# 4. 驗證運行
hermes-agent --version
```

---

## 四、 成果推回本機 Google Drive（同步閉環）

任務跑完後，成果直接透過 curl 或 rclone 回傳至 Google Drive 或雲端暫存，讓 Mac 本機自動秒級同步接收：

```bash
# 範例：任務產物壓縮打包
tar -czf task_result_$(date +%Y%m%d_%H%M%S).tar.gz output/
```

---

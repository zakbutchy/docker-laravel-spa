#!/usr/bin/env bash
set -e

cd /var/www/html

if [ ! -f package.json ]; then
    echo "package.json が見つかりません。フロントエンドのプロジェクトがまだ作成されていません。"
    echo "例: docker compose exec node npm create vite@latest . -- --template react"
    echo "作成後、コンテナを再起動すると開発サーバーが自動起動します。"
    exec tail -f /dev/null
fi

npm install

if npm run | grep -qE '^  dev$'; then
    # Vite（React/Vue等）の開発サーバーを起動
    # --host 0.0.0.0 を付けないとコンテナ外（ホスト）からアクセスできない
    exec npm run dev -- --host 0.0.0.0
fi

echo "package.json に dev スクリプトが見つかりません。コンテナを起動状態のまま維持します。"
exec tail -f /dev/null

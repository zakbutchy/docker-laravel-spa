# ベースイメージの指定（2026年8月時点のActive LTS: 24系, Debian bookworm slim）
FROM node:24-bookworm-slim

# コンテナ内のサーバー環境変数を設定
ENV TZ=Asia/Tokyo \
    # locale
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

# コンテナ内で作業する際のカレントディレクトリの指定
WORKDIR /var/www/html

COPY ./docker/node/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Vite（React/Vue）の開発サーバー用に5173ポートを開放
EXPOSE 5173

# package.json があれば npm install の上でdevスクリプト（Viteの開発サーバー）を起動、
# なければコンテナを起動したまま待機する
ENTRYPOINT [ "/entrypoint.sh" ]

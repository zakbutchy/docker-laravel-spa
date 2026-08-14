FROM nginx:1.30.4-alpine

ENV TZ=Asia/Tokyo

# nginx config file
# 作成した nginx のデフォルトのサーバー設定ファイルをコンテナ内にコピー
COPY ./docker/nginx/*.conf /etc/nginx/conf.d/

RUN chmod 644 /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html

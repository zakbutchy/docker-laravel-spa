FROM mysql:8.4

ENV TZ=Asia/Tokyo

# MySQL 追加設定ファイルをコピー
# 公式mysqlイメージは /etc/my.cnf（もしくは /etc/mysql/my.cnf）が
# `!includedir /etc/mysql/conf.d/` を読み込む構成になっているため、
# メインの設定ファイルを直接上書きせず conf.d 配下に追加すること
COPY ./docker/mysql/my.cnf /etc/mysql/conf.d/custom.cnf
# データ初期化用 SQL ファイルらをコピー
COPY ./docker/mysql/initdb.d /docker-entrypoint-initdb.d/

RUN chmod 644 /etc/mysql/conf.d/custom.cnf

FROM php:8.5-fpm-bookworm

# コンテナ内のサーバー環境変数を設定
ENV TZ=Asia/Tokyo \
    # locale
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

# パッケージのインストール
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    git \
    unzip \
    vim \
    locales \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    # ja_JP.UTF-8ロケールを有効化して生成（bookwormイメージにはデフォルトで未生成のため）
    && sed -i 's/^# *\(ja_JP.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    # パッケージインストールで使用したキャッシュファイル削除
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # PHPの拡張ライブラリインストール
    && docker-php-ext-install intl pdo_mysql zip bcmath pcntl \
    # xdebug / redis install
    && pecl install xdebug redis \
    && docker-php-ext-enable xdebug redis

# composer command（composer:2で最新2.x系を自動追従）
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# composer environment
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer

# 作成した設定ファイルをコンテナ内にコピー
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# コンテナ内で作業する際のカレントディレクトリの指定
WORKDIR /var/www/html

up:
	docker compose up -d
build:
	docker compose build
build-fresh:
	docker compose build --no-cache --force-rm
laravel-install:
	docker compose exec php composer create-project --prefer-dist laravel/laravel .
	@# If you want to specify a version, use the following command
	@# docker compose exec php composer create-project --prefer-dist  "laravel/laravel=11.*" .
create-laravel-project:
	rm -rf server/*
	mkdir -p server
	@make build
	@make up
	@make laravel-install
	docker compose exec php php artisan key:generate
	docker compose exec php php artisan storage:link
	@# php-fpmはwww-dataユーザーで動くため、rootが作成したこれらのディレクトリの所有者を合わせる
	docker compose exec php chown -R www-data:www-data storage bootstrap/cache
	docker compose exec php chmod -R 775 storage bootstrap/cache
	@# .envのDB_CONNECTIONをmysqlに変更してから実行すること（デフォルトはsqlite）
	# @make fresh
	@make ps
	docker compose exec php php artisan -V
install-packages:
	@# Horizonはredisキューの管理ダッシュボードであり必須ではない（queue自体はHorizon無しでも`php artisan queue:work`で動く）
	docker compose exec php composer require laravel/horizon
	docker compose exec php php artisan horizon:install
install-dev-packages:
	docker compose exec php composer require --dev barryvdh/laravel-ide-helper
	docker compose exec php composer require --dev barryvdh/laravel-debugbar
	docker compose exec php php artisan vendor:publish --provider="Fruitcake\LaravelDebugbar\ServiceProvider"
	docker compose exec php composer require --dev larastan/larastan
	docker compose exec php composer require --dev rector/rector
	docker compose exec php composer require --dev roave/security-advisories:dev-latest
	@# beyondcode/laravel-dump-serverは最新版でもilluminate/console ^12までしか対応しておらず、Laravel 13では入らない（2026年8月時点）
	# docker compose exec php composer require --dev beyondcode/laravel-dump-server
	# docker compose exec php composer require --dev laravel/telescope
	# docker compose exec php composer require pestphp/pest --dev --with-all-dependencies
init:
	docker compose up -d --build
	docker compose exec php composer install
	docker compose exec php cp .env.example .env
	docker compose exec php php artisan key:generate
	docker compose exec php php artisan storage:link
	docker compose exec php chown -R www-data:www-data storage bootstrap/cache
	docker compose exec php chmod -R 775 storage bootstrap/cache
	@make fresh
remake:
	@make destroy
	@make init
stop:
	docker compose stop
	@make ps
down:
	docker compose down --remove-orphans
down-v:
	docker compose down --remove-orphans --volumes
restart:
	@make stop
	@make up
destroy:
	docker compose down --rmi all --volumes --remove-orphans
ps:
	docker compose ps
logs:
	docker compose logs
logs-watch:
	docker compose logs --follow
log-nginx:
	docker compose logs nginx
log-nginx-watch:
	docker compose logs --follow nginx
log-php:
	docker compose logs php
log-php-watch:
	docker compose logs --follow php
log-mysql:
	docker compose logs mysql
log-mysql-watch:
	docker compose logs --follow mysql
nginx:
	docker compose exec nginx sh
php:
	docker compose exec php bash
migrate:
	docker compose exec php php artisan migrate
fresh:
	docker compose exec php php artisan migrate:fresh --seed
seed:
	docker compose exec php php artisan db:seed
rollback-test:
	docker compose exec php php artisan migrate:fresh
	docker compose exec php php artisan migrate:refresh
tinker:
	docker compose exec php php artisan tinker
test:
	docker compose exec php php artisan test
optimize:
	docker compose exec php php artisan optimize
optimize-clear:
	docker compose exec php php artisan optimize:clear
cache:
	docker compose exec php composer dump-autoload -o
	@make optimize
	docker compose exec php php artisan event:cache
	docker compose exec php php artisan view:cache
cache-clear:
	docker compose exec php composer clear-cache
	@make optimize-clear
	docker compose exec php php artisan event:clear
mysql-shell:
	docker compose exec mysql bash
mysql:
	docker compose exec mysql bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
redis:
	docker compose exec redis redis-cli
ide-helper:
	docker compose exec php php artisan clear-compiled
	docker compose exec php php artisan ide-helper:generate
	docker compose exec php php artisan ide-helper:meta
	docker compose exec php php artisan ide-helper:models --nowrite
node:
	docker compose exec node bash
composer-audit:
	docker compose exec php composer audit
npm-audit:
	docker compose exec node npm audit

# Laravel + SPA by Docker

## Overview

* [php:8.5-fpm-bookworm][php]
* [composer:2][composer]
* [node:24-bookworm-slim][node]
* [nginx:1.30.4-alpine][nginx]
* [mysql:8.4][mysql]
* [redis:8.10.0-alpine][redis]
* [phpmyadmin/phpmyadmin][phpmyadmin] (disabled by default, uncomment it in docker-compose.yml to use)
* [mailpit][mailpit]

Backend (Laravel, `server/`) and frontend SPA (React/Vue + Vite, `client/`) are kept in separate containers.
The frontend dev server in the `node` container starts automatically once a frontend project exists in `client/`.

[php]:https://hub.docker.com/_/php
[composer]:https://hub.docker.com/_/composer
[node]:https://hub.docker.com/_/node
[nginx]:https://hub.docker.com/_/nginx
[mysql]:https://hub.docker.com/_/mysql
[redis]:https://hub.docker.com/_/redis
[phpmyadmin]:https://hub.docker.com/_/phpmyadmin
[mailpit]:https://hub.docker.com/r/axllent/mailpit

**Note**: Versions go stale over time. Before starting real work, re-check the latest versions from each official source (Docker Hub, php.net, laravel.com, etc.).

## Build

Start a new project from this repository — either GitHub's "Use this template"
button (creates an independent repository with a fresh history, no `.git` cleanup
needed), or clone it and detach it manually:

```sh
cd project_path
# remove .git and start a fresh history for your new project
rm -rf .git
git init
```

Then, either way:

```sh
make build
make up
```

Ports and the mysql container's initial database/user/password have sensible
defaults baked into `docker-compose.yml`. If you want to override any of
them (e.g. to avoid a local port conflict), create a root `.env` file with
just the keys you want to change — see the `${VAR:-default}` entries in
`docker-compose.yml` for the full list (`WEB_PORT`, `NODE_PORT`, `DB_PORT`,
`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`, `REDIS_PORT`, `PMA_PORT`,
`MAILPIT_SMTP_PORT`, `MAILPIT_DASHBOARD_PORT`).

Use `make build-fresh` if you want to rebuild everything from scratch, ignoring the cache.

Check that nginx and PHP-FPM are wired up correctly before installing Laravel:

```bash
open http://localhost:8080/index.html
```

## How to create project

1.Install Laravel (latest)

```sh
make create-laravel-project
```

If you want to change the version:

```sh
# Specify the version to be installed
docker compose exec php composer create-project --prefer-dist  "laravel/laravel=13.*" .

docker compose exec php php artisan key:generate
docker compose exec php php artisan storage:link
docker compose exec php chown -R www-data:www-data storage bootstrap/cache
docker compose exec php chmod -R 775 storage bootstrap/cache
make ps
docker compose exec php php artisan -V
```

Since Laravel 11, the default `phpunit.xml` already runs tests against an in-memory SQLite database (`DB_CONNECTION=sqlite`, `DB_DATABASE=:memory:`), so no extra test-DB configuration is required out of the box.

2.Install recommended dev packages

```bash
make install-dev-packages
```

If you plan to use Redis-backed queues, also install Horizon:

```bash
make install-packages
```

The `php` container already includes the `redis` PECL extension (PhpRedis), which Laravel uses by default (`REDIS_CLIENT=phpredis`).

3.Frontend dev server (Vite)

Scaffold your frontend project inside `client/`. Any Vite template works
(`react`, `react-ts`, `vue`, `vue-ts`, `svelte`, etc.) — the framework choice
is entirely up to you:

```bash
docker compose exec node npm create vite@latest . -- --template react
docker compose restart node
```

The `node` container's entrypoint installs dependencies and starts the dev server automatically once `client/package.json` exists. If your `dev` script isn't backed by Vite (e.g. Angular's `ng serve`), its `--host` flag handling may differ, so you may need to adjust the startup command in `docker/node/entrypoint.sh`.

To call the Laravel API from the frontend, allow its origin (`http://localhost:5173` by default) in `server/config/cors.php`.

If HMR doesn't work correctly through the Docker port mapping, add this to `client/vite.config.js`:

```js
server: {
  host: true,
  hmr: {
    host: 'localhost'
  },
  watch: {
    usePolling: true
  }
}
```

4.Access

```bash
# Go to Laravel welcome page
open http://localhost:8080

# PhpMyAdmin
open http://localhost:8888/

# mailpit
open http://localhost:8025/

# Vite
open http://localhost:5173/
```

PhpMyAdmin is disabled by default (uncomment it in `docker-compose.yml` to use it at `http://localhost:8888/`). This setup assumes connecting to `localhost:3306` directly from a DB client such as DBeaver instead.

Use `make redis` to connect via redis-cli.

## Setup

* Edit `.env`, `config/app.php` and more...
* Since Laravel 11, the default `server/.env` uses `DB_CONNECTION=sqlite`. To connect to this project's mysql/redis containers instead, copy the contents of `templates/.env.template` into `server/.env` (replacing the matching keys). `DB_DATABASE`/`DB_USERNAME`/`DB_PASSWORD` must match whatever the mysql container was actually initialized with (its defaults live in `docker-compose.yml`, see the Build section above).
* Delete test_db and create a database for the new project.

## Xdebug

Append `pathMappings` to configurations in launch.json

```json
{
    "name": "Listen for Xdebug",
    "type": "php",
    "request": "launch",
    "port": 9003,
    "pathMappings": {
        "var/www/html/": "${workspaceRoot}/server"
    }
},
```

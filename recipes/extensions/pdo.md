# PDO extensions

```Dockerfile
# Install PDO extensions and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends sqlite3 libpq-dev && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install pdo_mysql pdo_pgsql
```
# PHP Image

## Nginx dependency

This image should be used with [NGINX as a reverse proxy container](https://github.com/adiachenko/docker-image-nginx-php). For example, using Docker Compose:

```yml
version: '3.7'

services:
  # Image: https://hub.docker.com/r/adiachenko/php
  php:
    image: adiachenko/php
    volumes:
      - ./:/opt/project:cached

  # Image: https://hub.docker.com/r/adiachenko/nginx-php
  nginx:
    depends_on:
      - php
    image: adiachenko/nginx-php
    environment:
      - NGINX_BACKEND_HOST=php
      - NGINX_BACKEND_PORT=9000
      - NGINX_SERVER_TYPE=laravel
    ports:
      - 8000:80
    volumes:
      - ./:/opt/project:cached
```

## Configuration

This image ships with the default php.ini for production environments.

The only notable change is opcache config, to prevent confusion when running container with unedited settings:
- `opcache.validate_timestamps` is set to 1 to (should be set to 0 in production)
- `opcache.revalidate_freq` is set to 0 (should be like this regardless of environment)

It is recommended that you change configuration using the following environment variables rather than hardcoding `php.ini` values in the image:

| Name                                | Default                           |
| ----------------------------------- | --------------------------------- |
| PHP_DISPLAY_ERRORS                  | Off                               |
| PHP_DISPLAY_STARTUP_ERRORS          | Off                               |
| PHP_ERROR_REPORTING                 | E_ALL & ~E_DEPRECATED & ~E_STRICT |
| PHP_MEMORY_LIMIT                    | 128M                              |
| PHP_POST_MAX_SIZE                   | 8M                                |
| PHP_UPLOAD_MAX_SIZE                 | 2M                                |
| PHP_REALPATH_CACHE_SIZE             | 4K                                |
| PHP_REALPATH_CACHE_TTL              | 120                               |
| PHP_OPCACHE_MEMORY_CONSUMPTION      | 128                               |
| PHP_OPCACHE_INTERNED_STRINGS_BUFFER | 8                                 |
| PHP_OPCACHE_MAX_ACCELERATED_FILES   | 10000                             |
| PHP_OPCACHE_MAX_WASTED_PERCENTAGE   | 5                                 |
| PHP_OPCACHE_VALIDATE_TIMESTAMPS     | 1                                 |
| PHP_OPCACHE_SAVE_COMMENTS           | 1                                 |

## Creating images

Build images:

```sh
docker build --no-cache -t adiachenko/php:7.4 .
docker build -t adiachenko/php:latest .
```

Push images to Docker Hub:

```
docker push adiachenko/php:7.4
docker push adiachenko/php:latest
```

## Recipes

If you plan to install additional packages, look first in the recipes folder for pre-made snippets with installation instructions.
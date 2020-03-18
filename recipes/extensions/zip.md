# ZIP extension

```Dockerfile
# Install ZIP extension
RUN apt-get update && apt-get install -y --no-install-recommends libzip-dev && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install zip
```
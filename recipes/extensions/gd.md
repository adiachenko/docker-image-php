# GD extension

```Dockerfile
# Install GD extension
RUN apt-get update && apt-get install -y --no-install-recommends zlib1g-dev libpng-dev && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install gd
```
# Memcached extension

```Dockerfile
# Install Memcached extension
RUN apt-get update && apt-get install -y --no-install-recommends libmemcached-dev && rm -rf /var/lib/apt/lists/* \
  && yes '' | pecl install memcached-3.1.5 \
  && docker-php-ext-enable memcached
```
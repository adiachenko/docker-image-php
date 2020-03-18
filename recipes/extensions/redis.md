# Redis extension

```Dockerfile
# Install Redis extension
RUN yes '' | pecl install redis-5.2.0 \
  && docker-php-ext-enable redis
```
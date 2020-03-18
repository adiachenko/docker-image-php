# Xdebug extension

```Dockerfile
# Install Xdebug extension
RUN yes '' | pecl install xdebug-2.9.2 \
  && docker-php-ext-enable xdebug
```
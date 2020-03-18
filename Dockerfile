FROM php:7.4-fpm-buster

# Define env variables for error reporting settings
ENV PHP_DISPLAY_ERRORS ${PHP_DISPLAY_ERRORS:-Off}
ENV PHP_DISPLAY_STARTUP_ERRORS ${PHP_DISPLAY_STARTUP_ERRORS:-Off}
ENV PHP_ERROR_REPORTING ${PHP_ERROR_REPORTING:-E_ALL & ~E_DEPRECATED & ~E_STRICT}

# Define env variables for memory settings
ENV PHP_MEMORY_LIMIT ${PHP_MEMORY_LIMIT:-128M}
ENV PHP_POST_MAX_SIZE ${PHP_POST_MAX_SIZE:-8M}
ENV PHP_UPLOAD_MAX_SIZE ${PHP_UPLOAD_MAX_SIZE:-2M}

# Define env variables for realpath cache settings
ENV PHP_REALPATH_CACHE_SIZE ${PHP_REALPATH_CACHE_SIZE:-4K}
ENV PHP_REALPATH_CACHE_TTL ${PHP_REALPATH_CACHE_TTL:-120}

# Define env variables for opcache settings
ENV PHP_OPCACHE_MEMORY_CONSUMPTION ${PHP_OPCACHE_MEMORY_CONSUMPTION:-128}
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER ${PHP_OPCACHE_INTERNED_STRINGS_BUFFER:-8}
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES ${PHP_OPCACHE_MAX_ACCELERATED_FILES:-10000}
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE ${PHP_OPCACHE_MAX_WASTED_PERCENTAGE:-5}
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS ${PHP_OPCACHE_VALIDATE_TIMESTAMPS:-1}
ENV PHP_OPCACHE_SAVE_COMMENTS ${PHP_OPCACHE_SAVE_COMMENTS:-1}

# Define env variables for Xdebug settings
ENV PHP_XDEBUG ${PHP_XDEBUG:-off}

# Install PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
  sqlite3 libpq-dev zlib1g-dev libpng-dev libzip-dev libmemcached-dev && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install bcmath pcntl exif opcache pdo_mysql pdo_pgsql gd zip \
  && yes '' | pecl install memcached-3.1.5 redis-5.2.0 xdebug-2.9.2 \
  && docker-php-ext-enable memcached redis xdebug

# Install Composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Install Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
  && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
  && mkdir -p /tmp/blackfire \
  && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
  && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
  && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
  && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Copy over PHP Configuration.
#   Development defaults: https://github.com/php/php-src/blob/master/php.ini-development
#   Producton defaults: https://github.com/php/php-src/blob/master/php.ini-production
COPY config/php.ini $PHP_INI_DIR/php.ini
COPY config/xdebug.ini $PHP_INI_DIR/conf.d/
COPY config/opcache.ini $PHP_INI_DIR/conf.d/

# Override default entrypoint
COPY entrypoint.sh /usr/local/bin/docker-php-entrypoint
RUN chmod +x /usr/local/bin/docker-php-entrypoint

WORKDIR /opt/project

#!/bin/sh
set -e

# conditionally disable xdebug based on env variable
if [ "$PHP_XDEBUG" = "off" ]; then
	rm $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

exec "$@"
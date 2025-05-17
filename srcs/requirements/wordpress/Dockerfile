FROM debian:oldstable

RUN apt-get update && apt-get install -y --no-install-recommends php-fpm curl ca-certificates php-mysql

RUN mkdir -p /srv/www && chown -R www-data: /srv/www

RUN mkdir -p /run/php && chown www-data:www-data /run/php

RUN curl https://wordpress.org/latest.tar.gz | tar zx -C /srv/www

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/wpscript.sh /usr/local/bin/wpscript.sh

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chmod +x /usr/local/bin/wpscript.sh /usr/local/bin/wp

ENTRYPOINT ["/usr/local/bin/wpscript.sh"]
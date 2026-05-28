# syntax=docker/dockerfile:1.7
FROM php:8.3.8-fpm-alpine3.20 AS runtime

ARG APP_UID=10001
ARG APP_GID=10001

RUN addgroup -g ${APP_GID} -S jirafeau \
    && adduser -u ${APP_UID} -S -D -H -G jirafeau jirafeau \
    && mkdir -p /var/www/html /run/php /var/lib/jirafeau/files /var/lib/jirafeau/links /var/lib/jirafeau/async /tmp/jirafeau \
    && chown -R jirafeau:jirafeau /var/www/html /run/php /var/lib/jirafeau /tmp/jirafeau

WORKDIR /var/www/html
COPY --chown=jirafeau:jirafeau . /var/www/html
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zz-jirafeau.ini
COPY docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod 0555 /usr/local/bin/healthcheck.sh

USER jirafeau:jirafeau
EXPOSE 9000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD ["/usr/local/bin/healthcheck.sh"]

CMD ["php-fpm","-F","-O"]

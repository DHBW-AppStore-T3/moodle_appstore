# syntax=docker/dockerfile:1
# Production image of our Moodle (this fork of Moodle core) for Kubernetes.
# Apache + mod_php 8.3 as UID 33 (www-data) on port 8080, read-only root
# filesystem friendly. Writable paths, all mounted from volumes by the chart
# (deployment: k8s/charts/moodle):
#   /var/www/moodledata   persistent ($CFG->dataroot)
#   /var/www/localcache   emptyDir   ($CFG->localcachedir)
#   /tmp                  emptyDir   (Apache runtime files, $CFG->tempdir)
# config.php (docker/config.php) is built from environment variables; the
# first start installs the database, later starts upgrade it (docker/init.sh).

FROM composer:2.8 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-progress --prefer-dist --ignore-platform-reqs

FROM php:8.3-apache
LABEL org.opencontainers.image.source="https://github.com/DHBW-AppStore-T3/moodle_appstore" \
      org.opencontainers.image.description="Moodle (DHBW AppStore T3 fork), Apache + PHP 8.3, non-root"

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libfreetype-dev libjpeg-dev libpng-dev libicu-dev libzip-dev libxml2-dev \
        libpq-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" gd intl zip soap exif opcache pgsql pdo_pgsql bcmath; \
    # Keep the runtime libraries of the extensions, drop compilers and headers.
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    find /usr/local -type f -executable -exec ldd '{}' ';' \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
        | sort -u | xargs -r dpkg-query --search | grep -v '^diversion by' | cut -d: -f1 | sort -u | xargs -r apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecursiveRemove=true; \
    rm -rf /var/lib/apt/lists/*; \
    php -r 'foreach (["gd","intl","zip","soap","exif","pgsql","sodium","mbstring","Zend OPcache","curl","xml","dom","xmlreader","simplexml","ctype","fileinfo","iconv","openssl","zlib"] as $e) { if (!extension_loaded($e)) { fwrite(STDERR, "missing PHP extension $e\n"); exit(1); } }'

# Apache: port 8080, runtime files under /tmp (the only writable path), logs
# to stdout/stderr, Moodle's router (r.php) as fallback.
RUN set -eux; \
    a2enmod rewrite headers; \
    a2dissite 000-default default-ssl 2>/dev/null || true; \
    sed -i 's/^Listen .*/Listen 8080/' /etc/apache2/ports.conf; \
    sed -i '/<IfModule ssl_module>/,/<\/IfModule>/d; /<IfModule mod_gnutls.c>/,/<\/IfModule>/d' /etc/apache2/ports.conf; \
    sed -i 's|^export APACHE_RUN_DIR=.*|export APACHE_RUN_DIR=/tmp/apache2|; s|^export APACHE_LOCK_DIR=.*|export APACHE_LOCK_DIR=/tmp/apache2|; s|^export APACHE_PID_FILE=.*|export APACHE_PID_FILE=/tmp/apache2/apache2.pid|' /etc/apache2/envvars
COPY docker/apache-moodle.conf /etc/apache2/sites-enabled/moodle.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/zz-moodle.ini

COPY --chown=root:root . /var/www/html
COPY --from=vendor /app/vendor /var/www/html/vendor
COPY docker/config.php /var/www/html/config.php
COPY docker/init.sh docker/is-installed.php docker/start.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/init.sh /usr/local/bin/start.sh \
    && mkdir -p /var/www/moodledata /var/www/localcache \
    && chown www-data:www-data /var/www/moodledata /var/www/localcache

WORKDIR /var/www/html
USER 33:33
EXPOSE 8080
CMD ["start.sh"]

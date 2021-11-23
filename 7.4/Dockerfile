FROM php:7.4-fpm-alpine AS min
WORKDIR /app
VOLUME /app
COPY config/php.ini /usr/local/etc/php/php.ini
RUN apk --update add --no-cache --virtual .build-deps \
    # Build dependencies
    build-base \
    gcc \
    autoconf \
    # Required extensions
    && docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \
    # Cleanup
    && apk del .build-deps \
    && rm -rf /tmp/pear /var/cache/apk/*

FROM min AS base
RUN apk --update add --no-cache \
    # Aditional packages
    npm \
    # Cleanup
    && rm -rf /var/cache/apk/*

FROM base AS newrelic
ARG NEW_RELIC_AGENT_VERSION
#ARG NEW_RELIC_LICENSE_KEY
#ARG NEW_RELIC_APPNAME
RUN apk --update add --no-cache \
    # required by newrelic agent
    libstdc++ gcompat

RUN curl -L https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux.tar.gz | tar -C /tmp -zx \
    && export NR_INSTALL_USE_CP_NOT_LN=1 \
    && export NR_INSTALL_SILENT=1 \
    && /tmp/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux/newrelic-install install \
    && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

# RUN sed -i -e "s/REPLACE_WITH_REAL_KEY/${NEW_RELIC_LICENSE_KEY}/" \
#     -e "s/newrelic.appname[[:space:]]=[[:space:]].*/newrelic.appname=\"${NEW_RELIC_APPNAME}\"/" \
#     -e '$anewrelic.distributed_tracing_enabled=true' \
#     -e '$anewrelic.daemon.address="newrelic-php-daemon:31339"' \
#     $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini

FROM base AS dev
ARG COMPOSER_VERSION=2.1.12
COPY config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN apk --update add --no-cache --virtual .build-deps \
    # Build dependencies 
    build-base \
    gcc \
    autoconf \
    && apk --update add --no-cache \
    # Dev packages
    php7-pecl-xdebug \
    bash \
    sqlite \
    && pecl install \
    xdebug \
    # Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    # Cleanup
    && apk del .build-deps \
    && rm -rf /tmp/pear \
    && rm -rf /var/cache/apk/*
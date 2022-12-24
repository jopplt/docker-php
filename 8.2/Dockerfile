FROM php:8.2.0-fpm-alpine3.17 AS min
WORKDIR /app
VOLUME /app
COPY config/php.ini /usr/local/etc/php/php.ini
RUN docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    opcache

FROM min AS base
ARG COMPOSER_VERSION=2.4.4
RUN apk --update add --no-cache --virtual .build-deps \
    build-base \
    autoconf \
    # Base packages
    && apk --update add --no-cache \
    bash \
    npm \
    freetype-dev libpng-dev libjpeg-turbo-dev \
    # Additional extensions
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    exif \
    gd \
    && pecl install -o -f redis \
    && docker-php-ext-enable \
    redis \
    exif \
    gd \
    # Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    # Cleanup
    && apk del .build-deps


## Waiting for newrelic support for PHP 8.2 ...
# FROM base AS newrelic
# ARG NEW_RELIC_AGENT_VERSION=10.4.0.316
# RUN apk --update add --no-cache libstdc++ gcompat
# RUN curl -L https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux-musl.tar.gz | tar -C /tmp -zx \
#     && export NR_INSTALL_USE_CP_NOT_LN=1 \
#     && export NR_INSTALL_SILENT=1 \
#     && /tmp/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux/newrelic-install install \
#     && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

FROM base AS dev
COPY config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN apk --update add --no-cache --virtual .build-deps \
    # Build dependencies 
    build-base \
    gcc \
    autoconf \
    linux-headers \
    && apk --update add --no-cache \
    # Dev packages
    php81-pecl-xdebug \
    sqlite \
    mysql-client \
    && pecl install \
    xdebug \
    # Cleanup
    && apk del .build-deps
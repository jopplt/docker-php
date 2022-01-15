FROM php:7.4-fpm-alpine3.13 AS min
WORKDIR /app
VOLUME /app
COPY config/php.ini /usr/local/etc/php/php.ini
RUN docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    opcache

FROM min AS base
ARG COMPOSER_VERSION=2.1.12
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

FROM base AS newrelic
ARG NEW_RELIC_AGENT_VERSION=9.18.1.303
RUN apk --update add --no-cache libstdc++ gcompat

RUN curl -L https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux.tar.gz | tar -C /tmp -zx \
    && export NR_INSTALL_USE_CP_NOT_LN=1 \
    && export NR_INSTALL_SILENT=1 \
    && /tmp/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux/newrelic-install install \
    && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

FROM base AS dev
COPY config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN apk --update add --no-cache --virtual .build-deps \
    # Build dependencies 
    build-base \
    gcc \
    autoconf \
    && apk --update add --no-cache \
    # Dev packages
    php7-pecl-xdebug \
    sqlite \
    && pecl install \
    xdebug \
    # Cleanup
    && apk del .build-deps
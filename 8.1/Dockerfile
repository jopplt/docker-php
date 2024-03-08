FROM php:8.1.13-alpine3.17 AS min
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
    icu-dev \
    # Additional extensions
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    exif \
    gd \
    intl \
    bcmath \
    && pecl install -o -f redis \
    && docker-php-ext-enable \
    redis \
    # Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    # Cleanup
    && apk del .build-deps

FROM base AS newrelic
ARG NEW_RELIC_AGENT_VERSION=10.7.0.319
ARG NR_INSTALL_USE_CP_NOT_LN=1
ARG NR_INSTALL_SILENT=1
RUN apk --update add --no-cache libstdc++ gcompat
RUN curl -L https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux-musl.tar.gz | tar -C $HOME -zx \
 && $HOME/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux-musl/newrelic-install install \
 && rm -rf $HOME/newrelic-php5-* $HOME/nrinstall*

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
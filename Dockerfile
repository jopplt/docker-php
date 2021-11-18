FROM php:7.4-fpm-alpine AS prod
WORKDIR /app
VOLUME /app
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
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    # Cleanup
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

FROM prod AS dev
ARG COMPOSER_VERSION=2.1.12
COPY config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY config/php.ini /usr/local/etc/php/php.ini 
RUN apk --update add --no-cache --virtual .build-deps \
    # Build dependencies
    build-base \
    gcc \
    autoconf \
    # Dev packages
    && apk --update add --no-cache \
    php7-pecl-xdebug \
    bash \
    sqlite \
    && pecl install \
    xdebug \
    # Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    # Cleanup
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*
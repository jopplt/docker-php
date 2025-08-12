FROM php:8.4.11-fpm-alpine3.21 AS base
WORKDIR /app
VOLUME /app
COPY config/php.ini /usr/local/etc/php/php.ini
RUN apk --update add --no-cache --virtual .build-deps \
    build-base \
    autoconf \
    # Base packages
    && apk --update add --no-cache \
    curl \
    git \
    bash \
    supervisor \
    freetype-dev libpng-dev libjpeg-turbo-dev \
    icu-dev \
    libzip-dev zip unzip \
    oniguruma-dev \
    libxml2-dev \
    # Additional extensions
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    exif \
    gd \
    intl \
    bcmath \
    mbstring \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    pcntl \
    zip \
    && pecl install -o -f \
    redis \
    apcu \
    && docker-php-ext-enable \
    redis \
    apcu \
    && pecl clear-cache \
    # Cleanup
    && apk del .build-deps

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
    php83-pecl-xdebug \
    sqlite \
    mysql-client \
    && pecl install \
    xdebug \
    # Cleanup
    && apk del .build-deps
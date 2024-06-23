# docker-php
PHP docker image for php/mysql developers. 

Link to DockerHub: https://hub.docker.com/r/jopplt/php/tags

## Tags
### `8.3-fpm-base`: Base image for PHP development
```
docker pull jopplt/php:8.3-fpm-base
```
Bundled with:
* Composer
* Node
* NPM

Includes the following extensions:
* `exif`
* `gd`
* `intl`
* `mysqli`
* `pdo`
* `pdo_mysql`
* `opcache`
* `zip`

Get a shell:
```
docker run --rm -it -v ${PWD}:/app jopplt/php:8.3-fpm-base sh
```

Custom `php.ini` configuration?:
```
docker run --rm -it -v ${PWD}:/app -v ${PWD}/config/php.ini:/usr/local/etc/php/php.ini jopplt/php:8.3-fpm-base sh
```

### `8.3-fpm-dev`: Base image with additional tools for local development
```
docker pull jopplt/php:8.3-fpm-dev
```
Bundled with:
* Composer
* Node
* Xdebug
* Sqlite
* Bash

Get a shell:
```
docker run --rm -it -v ${PWD}:/app jopplt/php:8.3-fpm-dev bash
```

Install composer dependencies on current folder (with ssh keys):
```
docker run --rm -v ${PWD}:/app -v ~/.ssh:/root/.ssh jopplt/php:8.3-fpm-dev composer install
```

Custom `xdebug.ini` configuration?:
```
docker run --rm -it -v ${PWD}:/app -v ${PWD}/config/xdebug.ini:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini jopplt/php:8.3-fpm-dev bash
```

## Local build & run

```
docker build --tag php:8.3-fpm-dev 8.3
```
```
docker run --rm -it -v ${PWD}:/app php:8.3-fpm-dev bash
```

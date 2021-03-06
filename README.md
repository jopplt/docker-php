# docker-php
PHP docker image for php/mysql developers. 

Link to DockerHub: https://hub.docker.com/r/jopplt/php/tags

## Tags
### `7.4-fpm-min`: Minimal PHP 7.4 fpm
```
docker pull jopplt/php:7.4-fpm-min
```
Includes the following extensions:
* `pdo_mysql`
* `opcache`
* `exif`
* `gd`

Get a shell:
```
docker run --rm -it -v ${PWD}:/app jopplt/php:7.4-fpm-min sh
```

Custom `php.ini` configuration?:
```
docker run --rm -it -v ${PWD}:/app -v ${PWD}/config/php.ini:/usr/local/etc/php/php.ini jopplt/php:7.4-fpm-min sh
```

### `7.4-fpm-dev`: PHP 7.4 fpm for development purposes
```
docker pull jopplt/php:7.4-fpm-dev
```
Includes:
* composer
* xdebug
* sqlite
* bash
* npm

Get a shell:
```
docker run --rm -it -v ${PWD}:/app jopplt/php:7.4-fpm-dev bash
```

Install composer dependencies on current folder (with ssh keys):
```
docker run --rm -v ${PWD}:/app -v ~/.ssh:/root/.ssh jopplt/php:7.4-fpm-dev composer install
```

Custom `xdebug.ini` configuration?:
```
docker run --rm -it -v ${PWD}:/app -v ${PWD}/config/xdebug.ini:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini jopplt/php:7.4-fpm-dev bash
```

### `7.4-fpm-newrelic`: PHP 7.4 fpm with Newrelic Agent
```
docker pull jopplt/php:7.4-fpm-newrelic
```

Requirements:
* Newrelic daemon running in a separate container. Please refer to [docs.newrelic.com](https://docs.newrelic.com/docs/apm/agents/php-agent/advanced-installation/docker-other-container-environments-install-php-agent/) for more information
* `newrelic.ini` configuration

```
docker run -d -v ${PWD}:/app -v ${PWD}/config/newrelic.ini:/usr/local/etc/php/conf.d/newrelic.ini jopplt/php:7.4-fpm-newrelic
```

## Local build & run

```
docker build --tag php:7.4-fpm-dev 7.4
```
```
docker run --rm -it -v ${PWD}:/app php:7.4-fpm-dev bash
```

FROM php:8.2-apache-bullseye
EXPOSE 80
MAINTAINER Madpeter

# Install necessary packages / Install PHP extensions which depend on external libraries
RUN \
    apt-get update \
    && echo 'adding SSL + cron + imagemagic + zip support' \
    && apt-get install -y openssl \
    && apt-get install -y cron \
    && apt-get install -y libpng-dev \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y libzip-dev \
    && apt-get install -y unzip \
    && apt-get update \
    && apt-get install -y libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	&& docker-php-ext-enable imagick \
    && echo 'Adding font support' \
    && apt-get install -y libfreetype6-dev \
    && echo 'oniguruma?' \
    && apt-get install -y libonig-dev \
    && apt-get install -y --no-install-recommends libssl-dev libcurl4-openssl-dev \
    && docker-php-ext-configure curl --with-curl \
    && docker-php-ext-install curl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install calendar \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install curl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install calendar \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && docker-php-ext-install mbstring \
    && a2enmod rewrite \
    && a2enmod expires \
    && apt-get update \
    && apt-get clean

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends libffi-dev; \
	rm -rf /var/lib/apt/lists/*; \
	docker-php-ext-install ffi

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd \
    && apt-get clean


# Setup Zend OP Cache
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.interned_strings_buffer=16'; \
    echo 'opcache.max_accelerated_files=1500'; \
    echo 'opcache.memory_consumption=256'; \
    echo 'opcache.revalidate_freq=0'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini
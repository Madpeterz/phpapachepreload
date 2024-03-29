FROM php:7.4-apache

MAINTAINER Madpeter

# Install necessary packages / Install PHP extensions which depend on external libraries
RUN \
    apt-get update \
    && apt-get install -y openssl \
    && apt-get install -y cron \
    && apt-get install -y libpng-dev \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y libzip-dev \
    && apt-get install -y unzip

RUN \
    apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	&& docker-php-ext-enable imagick

RUN \
    echo 'Adding font support' \
    && apt-get install -y libfreetype6-dev \
    && echo 'oniguruma?' \
    && apt-get install -y libonig-dev \
    && apt-get install -y --no-install-recommends libssl-dev libcurl4-openssl-dev \
    && docker-php-ext-configure curl --with-curl \
    && docker-php-ext-install -j$(nproc) \
        curl \
        mysqli \
        calendar \
        opcache \
        zip \
        mbstring \
        gd \
    && a2enmod rewrite \ 
    && a2enmod expires \
    && apt-get update

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
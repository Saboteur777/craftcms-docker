# Use this image as base
FROM php:apache

# Change DocumentRoot according to documentation found at:
# https://hub.docker.com/_/php/
ENV APACHE_DOCUMENT_ROOT /var/www/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install Craft CMS 3 requirements' requirements ¯\_(ツ)_/¯
RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libcurl4-openssl-dev \
        libxml2-dev \
        libmagickwand-dev imagemagick \
        mariadb-client \
        libicu-dev \
        jpegoptim optipng gifsicle webp \
    && apt-get clean \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include --with-jpeg-dir=/usr/include

# Install Craft CMS 3 requirements
RUN docker-php-ext-install -j$(nproc) curl dom gd intl iconv json mbstring mysqli opcache pdo pdo_mysql simplexml zip
RUN pecl install imagick && docker-php-ext-enable imagick.so

## Configure Apache server
RUN a2enmod rewrite expires headers ssl

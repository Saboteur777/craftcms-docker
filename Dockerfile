# Use this image as base
FROM php:apache

# Change DocumentRoot according to documentation found at:
# https://hub.docker.com/_/php/
ENV APACHE_DOCUMENT_ROOT /var/www/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install Craft CMS 3 requirements' requirements ¯\_(ツ)_/¯
RUN CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    # curl
    libcurl4-openssl-dev \
    # dom
    libxml2-dev \
    # gd
    libpng-dev \
    # imagemagick
    libmagickwand-dev \
    # zip
    libzip-dev \
    # Craft updater
    mariadb-client \
    && apt clean

# Install Craft CMS 3 requirements
RUN docker-php-ext-install -j$(nproc) curl dom gd intl mysqli opcache pdo_mysql zip && \
    pecl install imagick-3.4.3 && docker-php-ext-enable imagick

## Configure Apache server
RUN a2enmod rewrite expires headers ssl

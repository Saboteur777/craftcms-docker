# Use this image as base
FROM php:apache

# Change DocumentRoot according to documentation found at:
# https://hub.docker.com/_/php/
ENV APACHE_DOCUMENT_ROOT /var/www/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install Craft CMS 3 requirements' requirements ¯\_(ツ)_/¯
RUN apt-get update && apt-get install -y \
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
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include --with-jpeg-dir=/usr/include

# Install Craft CMS 3 requirements
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) dom
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install -j$(nproc) json
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) simplexml
RUN docker-php-ext-install -j$(nproc) zip
RUN pecl install imagick
RUN docker-php-ext-enable imagick.so

## Configure Apache server
RUN a2enmod rewrite expires headers ssl

CMD ["apache2-foreground"]

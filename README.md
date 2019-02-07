# craftcms-docker

![Last commit](https://badgen.net/github/last-commit/Saboteur777/craftcms-docker/v3)
![Docker Build mode](https://badgen.net/badge/docker%20build/automated)
[![Docker layers count](https://images.microbadger.com/badges/image/webmenedzser/craftcms.svg)](https://microbadger.com/images/webmenedzser/craftcms)
![Docker Pull count](https://badgen.net/docker/pulls/webmenedzser/craftcms)
![Keybase.io PGP](https://badgen.net/keybase/pgp/Saboteur777)

> **Separated [nginx](https://cloud.docker.com/u/webmenedzser/repository/docker/webmenedzser/craftcms-nginx) + [php-fpm](https://cloud.docker.com/u/webmenedzser/repository/docker/webmenedzser/craftcms-php) sister images are available.**

This Docker image aims to be as simple as possible to run Craft CMS - if you have special dependencies, define this image as a base in your Dockerfile (FROM: webmenedzser/craftcms:latest) and extend it as you like. 

The image will be based on the `php:apache` image, which ships the latest stable PHP. 

Current PHP version: **7.3.1**


### Change user and group of PHP
You can change which user should run PHP - just build your image by extending this one, e.g.:

**Dockerfile**
```
FROM: webmenedzser/craftcms:latest

[...]
# Add APACHE_RUN_USER user
RUN useradd -u 1000 -G www-data -M saboteur
[...]
```

AND 

**docker-compose.yml**
```
[...]
    environment:
      - APACHE_RUN_USER=#1000
[...]
```

This will instruct Docker to add a new user during the build process with user ID 1000, add it to the www-data group and run Apache as user 1000. 

### Add custom PHP settings
You can easily add new PHP settings to the image. Just place your `.ini` file in e.g. the `.docker/php` folder, and `COPY` it:

**Dockerfile**
```
FROM: webmenedzser/craftcms:latest

[...]
COPY .docker/web/settings-override.ini /usr/local/etc/php/conf.d/
[...]
```
Opcache is enabled by default, so if you want to disable it (for local dev) you can do it with the method mentioned above:

**disable-opcache.ini**
```
opcache.enable = 0;
```

### Example usage

**docker-compose.yml**

```
volumes:
  database_volume: {}

version: '3.6'
services:

  web:
    image: webmenedzser/craftcms:latest
    volumes:
      - ./:/var/www/

  database:
    image: mariadb:latest
    volumes:
     - database_volume:/var/lib/mysql
```

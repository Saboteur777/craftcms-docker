# craftcms-docker

**Separated [nginx](https://cloud.docker.com/u/webmenedzser/repository/docker/webmenedzser/craftcms-nginx) + [php-fpm](https://cloud.docker.com/u/webmenedzser/repository/docker/webmenedzser/craftcms-php) sister images are available.**

This Docker image aims to be as simple as possible to run Craft CMS - if you have special dependencies, define this image as a base in your Dockerfile (FROM: webmenedzser/craftcms:latest) and extend it as you like. 

The image will be based on the php:apache image, which ships the latest stable PHP. 

Current PHP version: **7.3.0**

FROM php:7-fpm-alpine
MAINTAINER Rômulo Guimarães <romulo1984@gmail.com>

ENV TERM=xterm

RUN echo "http://dl-8.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories;

# Usa bibliotecas especiais para compilar a extensão gd
RUN apk add --update libxml2-dev openssl-dev curl-dev icu-dev \
        freetype freetype-dev libjpeg-turbo libjpeg-turbo-dev libpng libpng-dev libmcrypt-dev bash \
        git ca-certificates gzip tar nodejs nano && \
    apk add libressl2.4-libcrypto libressl2.4-libssl --update-cache --repository http://dl-8.alpinelinux.org/alpine/v3.5/main && \
    apk add php7-sqlite3 php7-pdo_sqlite php7-openssl --update-cache --repository http://dl-8.alpinelinux.org/alpine/v3.5/community && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-install json xml mysqli pdo pdo_mysql phar curl \
    dom intl ctype opcache posix exif json xml mysqli pdo pdo_mysql \
    phar curl dom intl ctype opcache posix exif mcrypt mbstring session zip && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer && \
    rm -rf /var/cache/apk/* && \
    ln -sf /dev/stdout /var/log/fpm-access.log && \
    ln -sf /dev/stderr /var/log/fpm-error.log
FROM php:7.4-apache

# 1. Copiez la configuration de Nginx
#COPY ./nginx.back.conf /etc/nginx/conf.d/default.conf

# 2 Set working directory
WORKDIR /var/www/html

# Install packages
RUN apt-get update && apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    cron \
    unzip \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    librabbitmq-dev \
    libzip-dev \
    libonig-dev \
    locales \
    jpegoptim optipng pngquant gifsicle \
    g++ \
    && pecl install amqp \
    && docker-php-ext-enable amqp \
    && apt-get clean

# Apache configuration
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
ARG APP_DOMAIN

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
## RUN sed -ri -e 's!#ServerName www.example.com!${APP_DOMAIN}!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite headers

# Common PHP Extensions
RUN docker-php-ext-install bz2 intl iconv bcmath opcache calendar pdo_mysql mbstring zip exif pcntl\
  && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ \
  && docker-php-ext-install gd \
  && docker-php-ext-install sockets \
  && docker-php-ext-enable amqp

# Ensure PHP logs are captured by the container
ENV LOG_CHANNEL=stderr

# Set a volume mount point for your code
VOLUME /var/www/html

# Copy code and run composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY . /var/www/tmp
RUN cd /var/www/tmp && composer install --no-dev

# Ensure the entrypoint file can be run
RUN chmod +x /var/www/tmp/docker-entrypoint.sh
ENTRYPOINT ["/var/www/tmp/docker-entrypoint.sh"]

# The default apache run command
CMD ["apache2-foreground"]

# Démarrez le serveur PHP-FPM
#CMD ["php-fpm"]


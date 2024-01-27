FROM php:8.3-fpm

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install PHP extensions
RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
      zip \ 
      pdo_mysql \
      gmp \
      zlib

# Install Supervisor
RUN apt-get update && apt-get install -y supervisor

RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Add a process manager for have both artisan serve and discord listener

# Create directory
RUN mkdir '/home/discord-goat-music'

COPY . /home/discord-goat-music

WORKDIR /home/discord-goat-music

# Remove all local composer.lock and vendor to have clean install
RUN rm composer.lock && rm -rf vendor

# Install dependencies
RUN composer install

# Run Laravel commands
RUN php artisan optimize:clear

RUN php artisan storage:link

RUN chmod 555 -R ./storage

# Run supervisor 
CMD ["/usr/bin/supervisord"]

EXPOSE 8080


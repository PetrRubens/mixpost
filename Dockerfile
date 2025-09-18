FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

WORKDIR /var/www/apps/server

RUN composer install --no-dev --optimize-autoloader

# Expose port
EXPOSE 8080

# Run migrations and start Laravel
CMD php artisan migrate --force || true && php artisan serve --host=0.0.0.0 --port=8080

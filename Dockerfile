FROM php:7.4.10-apache
COPY 000-default.conf /var/apache2/sites-available/
COPY php.ini /var/php/7.4/apache2/
RUN apt-get update && apt-get install -y \
  unzip \
  libzip-dev \
  libxml2-dev && docker-php-ext-install pdo pdo_mysql zip xml && a2enmod rewrite
WORKDIR /var/www/html/
RUN mkdir csweb 
WORKDIR /var/www/html/csweb/
ADD https://www2.census.gov/software/cspro/download/csweb.zip ./
RUN unzip csweb.zip && chown -R www-data:www-data /var/www/html/csweb && chmod -R 775 /var/www/html/csweb
VOLUME [ "/var/www/html/csweb" ]
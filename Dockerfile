# Startup from alpine
FROM alpine:latest
LABEL Maintainer = "DzikrRully"
LABEL Description = "PHPNuxBill - PHP Mikrotik Billing base on Latest Alpine Images."

# Setup document root
WORKDIR /var/www/html
VOLUME /var/www/html

# Expose the port nginx & mysql is reachable on
EXPOSE 80 3306 1812/udp 1813/udp

# Install packages
RUN apk add --no-cache \
    nginx \
    php82 \
    php82-fpm \
    php82-gd \
    php82-mbstring \
    php82-mysqli \
    php82-session \
    php82-pdo \
    php82-pdo_mysql \
    php82-zip \
    mysql \
    mysql-client \
    libzip-dev \
    zip \
    unzip \
    git \
    wget \
    freeradius \
    freeradius-mysql \
    freeradius-utils \
    supervisor

# Clone Git PHPNuxBill
RUN git clone https://github.com/hotspotbilling/phpnuxbill.git /tmp/gitclone

# Move Cloned Git to html folder
RUN mv /tmp/gitclone/* /var/www/html/

# Configure nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Configure MySQL
COPY conf/my.cnf /etc/mysql/my.cnf
COPY conf/mysql.sh /app/mysql.sh
RUN chmod +x /app/mysql.sh

# Configure PHP-FPM
COPY conf/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY conf/php.ini /etc/php82/conf.d/custom.ini

# Configure supervisord
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN chown -R nginx:nginx /var/www/html/

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Startup from alpine
FROM alpine:latest
LABEL Maintainer = "DzikrRully"
LABEL Description = "PHPNuxBill - PHP Mikrotik Billing base on Latest Alpine Images."

# Setup document root
WORKDIR /var/www/html

# Install nginx, mysql, freeradius, and supervisor
RUN apk update && apk add --no-cache libzip-dev zip unzip git wget nano nginx mysql mysql-client freeradius freeradius-mysql freeradius-utils supervisor

# Install php and phpnuxbill dependencies
RUN apk add php82 php82-fpm php82-mysqli php82-session php82-pdo php82-pdo_mysql php82-xml php82-zip php82-gd php82-curl php82-pear php82-ldap php82-mbstring php82-soap php82-json

# Clone Git PHPNuxBill
RUN git clone https://github.com/hotspotbilling/phpnuxbill.git /tmp/gitclone

# Move Cloned Git to html folder
RUN mv /tmp/gitclone/* /var/www/html/

# Copy nginx.conf file to /etc/nginx
COPY nginx.conf /etc/nginx

# Copy supervisor.conf file to /etc/supervisor
COPY supervisor.conf /etc/supervisor

# Expose port 80 for nginx
EXPOSE 80

# Start supervisor service
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisor.conf"]

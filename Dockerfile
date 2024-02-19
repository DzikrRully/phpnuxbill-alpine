FROM alpine:latest

# Install nginx, mysql, freeradius, and supervisor
RUN apk update && apk add nginx mysql mysql-client freeradius supervisor

# Install php and phpnuxbill dependencies
RUN apk add php php-fpm php-mysqli php-session php-pdo php-pdo_mysql php-xml php-xmlrpc php-zip php-gd php-curl php-pear php-ldap php-mbstring php-soap php-json

# Download and extract phpnuxbill
RUN wget 1 -O /tmp/phpnuxbill.tar.gz && \
    tar xzf /tmp/phpnuxbill.tar.gz -C /var/www/html && \
    rm /tmp/phpnuxbill.tar.gz

# Copy nginx.conf file to /etc/nginx
COPY nginx.conf /etc/nginx

# Copy supervisor.conf file to /etc/supervisor
COPY supervisor.conf /etc/supervisor

# Expose port 80 for nginx
EXPOSE 80

# Start supervisor service
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisor.conf"]

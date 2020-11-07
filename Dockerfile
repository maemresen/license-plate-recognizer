
FROM php:7.3-apache

RUN chown -R www-data /var/www/html

COPY install-openalpr.sh /root/install-openalpr.sh
RUN chmod +x /root/install-openalpr.sh
RUN /root/install-openalpr.sh
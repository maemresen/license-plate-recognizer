
FROM license-plate-recognizer-base:dev

COPY ./src /var/www/html
RUN chown -R www-data /var/www/html

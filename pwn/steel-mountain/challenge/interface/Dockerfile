FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y apache2 && \
  rm -rf /var/lib/apt/lists/*

RUN a2enmod proxy && \
  a2enmod proxy_http && \
  a2enmod ssl && \
  rm /etc/apache2/sites-enabled/000-default.conf
COPY interface.conf /etc/apache2/sites-enabled/
COPY steelmountain.crt /etc/ssl/steelmountain.crt
COPY steelmountain.key /etc/ssl/steelmountain.key

COPY htdocs /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R -w /var/www/html

EXPOSE 443

CMD apache2ctl -D FOREGROUND

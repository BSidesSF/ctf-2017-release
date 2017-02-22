FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y apache2 && \
  a2enmod cgi && \
  a2enmod rewrite && \
  rm -rf /var/lib/apt/lists/* && \
  rm /etc/apache2/sites-enabled/000-default.conf
COPY sensor.conf /etc/apache2/sites-enabled/

RUN useradd -m sensor && \
  usermod -a -G sensor www-data
COPY sensor.cgi /home/sensor/sensor.cgi
COPY sensors /home/sensor/sensors
COPY flag.txt /home/sensor/flag.txt
RUN chown -R root:sensor /home/sensor && \
  chmod 555 /home/sensor/sensor.cgi && \
  chmod 440 /home/sensor/flag.txt /home/sensor/sensors/*.cfg && \
  chmod -R ugo-w /home/sensor

EXPOSE 80

CMD apache2ctl -D FOREGROUND

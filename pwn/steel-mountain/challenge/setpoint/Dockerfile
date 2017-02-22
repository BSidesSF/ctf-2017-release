FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y apache2 && \
  a2enmod cgi && \
  a2enmod rewrite && \
  rm -rf /var/lib/apt/lists/* && \
  rm /etc/apache2/sites-enabled/000-default.conf
COPY setpoint.conf /etc/apache2/sites-enabled/

RUN useradd -m setpoint && \
  usermod -a -G setpoint www-data
COPY setpoint.cgi /home/setpoint/setpoint.cgi
COPY flag.txt /home/setpoint/flag.txt

RUN chown -R root:setpoint /home/setpoint && \
  chmod 555 /home/setpoint/setpoint.cgi && \
  chmod 440 /home/setpoint/flag.txt

EXPOSE 80

CMD apache2ctl -D FOREGROUND

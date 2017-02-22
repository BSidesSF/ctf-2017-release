FROM php:7.0-apache

# Upload the PHP stuff
ADD php_src/*.php /var/www/html/

# Upload the binary part
RUN mkdir /home/ctf
WORKDIR /home/ctf
ADD c_src/* /home/ctf/
RUN make

EXPOSE 80

FROM ubuntu:xenial

RUN apt-get update && apt-get install -y xinetd gcc ucspi-tcp lua5.2

RUN adduser --disabled-password --gecos '' ctf
WORKDIR /home/ctf
ADD byteme.lua /home/ctf/
ADD byteme.xinetd /etc/xinetd.d/byteme
RUN service xinetd restart

RUN chown -R root:root .

EXPOSE 1942

CMD service xinetd restart && sleep infinity

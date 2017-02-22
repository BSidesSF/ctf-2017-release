FROM ubuntu:xenial

RUN adduser --disabled-password --gecos '' ctf

RUN apt-get update && apt-get install -y xinetd gcc make libc6-dev-i386

WORKDIR /home/ctf
ADD src/* /home/ctf/
RUN make
RUN chown -R root:root .

ADD nibbler.xinetd /etc/xinetd.d/nibbler

USER root
EXPOSE 1338

CMD service xinetd restart && sleep infinity

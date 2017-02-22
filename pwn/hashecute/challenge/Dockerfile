FROM ubuntu:xenial

RUN adduser --disabled-password --gecos '' ctf

RUN apt-get update && apt-get install -y xinetd gcc make libc6-dev-i386 libssl-dev

WORKDIR /home/ctf
ADD src/* /home/ctf/
RUN make
RUN chown -R root:root .

ADD hashecute.xinetd /etc/xinetd.d/hashecute

USER root
EXPOSE 2525

CMD service xinetd restart && sleep infinity

FROM ubuntu:xenial

RUN adduser --disabled-password --gecos '' ctf

RUN apt-get update && apt-get install -y xinetd gcc make libc6-dev-i386 coreutils

WORKDIR /home/ctf
ADD src/* /home/ctf/
RUN make
RUN chown -R root:root .

ADD shortest.xinetd /etc/xinetd.d/shortest

EXPOSE 8890

CMD service xinetd restart && sleep infinity

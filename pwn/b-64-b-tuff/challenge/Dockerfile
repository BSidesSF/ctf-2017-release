FROM ubuntu:xenial

RUN adduser --disabled-password --gecos '' ctf

RUN apt-get update && apt-get install -y xinetd gcc make libc6-dev-i386 coreutils

WORKDIR /home/ctf
ADD src/* /home/ctf/
RUN make
RUN chown -R root:root .

ADD b-64-b-tuff.xinetd /etc/xinetd.d/b-64-b-tuff

# Set up xinetd
ADD xinetd.conf /etc/xinetd.conf
RUN mkdir /var/log/xinetd/


USER root
EXPOSE 5757

CMD service xinetd restart && tail -F /var/log/xinetd/xinetd.log

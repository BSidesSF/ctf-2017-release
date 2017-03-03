FROM ruby:2.3

RUN apt-get update && apt-get install -y xinetd
RUN adduser --disabled-password --gecos '' ctf

WORKDIR /home/ctf
ADD src/* /home/ctf/

ADD beez.xinetd /etc/xinetd.d/beez
RUN service xinetd restart

RUN chown -R root:root .

EXPOSE 666

CMD service xinetd restart && sleep infinity

FROM httpd:latest

RUN apt-get update && apt-get -y install git
ADD ./src/ /usr/local/apache2/htdocs/
RUN sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /usr/local/apache2/conf/httpd.conf

WORKDIR /usr/local/apache2/htdocs/
RUN git init

RUN git config user.email "thezuck@therealzuck.zuck"
RUN git config user.name "Mark Zuckerberg"

RUN git add index.html && git commit -m "First commit on my website"
RUN sed -i s/vitising/visiting/ index.html
RUN echo "Your flag is... FLAG:what_is_HEAD_may_never_die" >> index.html
RUN git commit -am "Fixed a spelling error"

RUN git reset --hard HEAD~1
RUN sed -i 's/homepage/homepage, there are no flags here./' index.html
RUN git commit -am "Wooops, didn't want to commit that. Rebased."

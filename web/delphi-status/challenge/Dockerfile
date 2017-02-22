FROM ruby:2.3

# Install prereqs

# Create a new user in the container
RUN adduser --disabled-password --gecos '' ctf
ADD . /usr/src/app
ADD ./flag.txt /home/ctf/flag.txt
RUN rm /usr/src/app/Dockerfile
WORKDIR /usr/src/app
RUN bundler install

EXPOSE 8080
USER ctf
CMD ["ruby", "./app.rb"]

# To run: docker run -p 8080:8080 delphi-status

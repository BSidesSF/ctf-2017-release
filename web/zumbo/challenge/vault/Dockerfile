FROM node:6
RUN npm install -g http-server
RUN mkdir /server
WORKDIR /server
RUN echo 'FLAG: BRICK_HOUSE_BEATS_THE_WOLF' > /server/flag
CMD http-server .

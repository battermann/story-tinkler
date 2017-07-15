FROM debian:latest

# prepare
RUN apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y install curl
RUN apt-get -y install gnupg2 

# install node, npm
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs

# install elm stuff
RUN npm install elm@0.18.0 -g
RUN npm install create-elm-app@1.1.0 -g
 
# install nginx
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# copy files
RUN mkdir /story-tinkler
COPY ./ /story-tinkler

WORKDIR /story-tinkler
RUN elm-app build
RUN cp -r /story-tinkler/build/* /var/www/html

CMD echo '#!/bin/sh\n\
\n\
/bin/sed -i "s/.*listen 80 default_server;.*/        listen $PORT;/" /etc/nginx/sites-enabled/default && nginx\n\
nginx' > /story-tinkler/nginx-start.sh && chmod +x /story-tinkler/nginx-start.sh && /bin/bash /story-tinkler/nginx-start.sh

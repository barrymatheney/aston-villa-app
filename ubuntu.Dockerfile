### STAGE 1: Build ###
#FROM node:latest AS build
FROM debian:latest AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y   && apt-get install -y apt-utils nodejs curl wget
RUN curl -L https://www.npmjs.com/install.sh | sh

#RUN npm install -g protractor
#RUN webdriver-manager update
RUN npm install karma
RUN npm install karma --save-dev
RUN npm install karma-jasmine karma-chrome-launcher jasmine-core --save-dev
RUN npm install -g karma-cli


WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

RUN ./node_modules/karma/bin/karma start && ng test
#RUN webdriver-manager start



### STAGE 2: Run ###
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

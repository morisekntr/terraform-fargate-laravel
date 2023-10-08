FROM node:16.13-alpine as node
FROM nginx:1.20-alpine
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

ENV TZ='Asia/Tokyo'

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++

# node command
COPY --from=node /usr/local/bin /usr/local/bin
# npm command
COPY --from=node /usr/local/lib /usr/local/lib
# nginx config file
COPY ./infra/docker/development/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /work/laravel

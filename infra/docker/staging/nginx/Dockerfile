FROM node:16.13-alpine as node

WORKDIR /build
COPY ./laravel .
COPY ./laravel/.env.staging .env
ARG VITE_PUSHER_APP_KEY
ARG VITE_PUSHER_APP_CLUSTER
RUN npm install
RUN VITE_PUSHER_APP_KEY=${VITE_PUSHER_APP_KEY} VITE_PUSHER_APP_CLUSTER=${VITE_PUSHER_APP_CLUSTER} npm run build

FROM nginx:1.20-alpine
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

ENV TZ='Asia/Tokyo'

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++

# nginx config file
COPY ./infra/docker/staging/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /work/laravel
COPY --from=node /build/public ./public

FROM nginx:alpine
LABEL org.opencontainers.image.title="my-custom-nginx"
LABEL maintainer="0-hu"
ENV APP_ENV=dev
COPY app/ /usr/share/nginx/html/
EXPOSE 80

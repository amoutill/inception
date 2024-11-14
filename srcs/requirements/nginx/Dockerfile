FROM alpine:3.19

RUN apk upgrade --no-cache -a && \
    apk add --no-cache nginx

USER nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]

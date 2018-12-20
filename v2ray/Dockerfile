FROM alpine:latest

RUN apk upgrade \
 && apk add --no-cache ca-certificates curl jq  \
 && mkdir -m 777 /v2ray
 
ENV UUID=none CERT_PEM=none KEY_PEM=none VER=none

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh 

ENTRYPOINT  /entrypoint.sh 

EXPOSE 10086

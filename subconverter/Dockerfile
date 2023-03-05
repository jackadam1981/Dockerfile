FROM alpine:latest
MAINTAINER Tindy X <tindy.it@gmail.com>

# switch repo for usage in China
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# build minimized
RUN apk update && apk upgrade
RUN	apk add git g++ build-base linux-headers cmake
RUN apk add libressl-dev curl-dev rapidjson-dev libevent-dev pcre-dev yaml-cpp-dev
RUN    git clone https://github.com/tindy2013/subconverter && \
    cd subconverter && \
    cmake . && \
    make -j4 && \
    mv subconverter base/ && \
    apk add curl yaml-cpp libevent && \
    apk del git gcc g++ build-base linux-headers cmake libressl-dev curl-dev rapidjson-dev libevent-dev yaml-cpp-dev

# set entry
CMD /subconverter/base/subconverter
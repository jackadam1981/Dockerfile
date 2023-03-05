FROM alpine:latest
MAINTAINER Tindy X <tindy.it@gmail.com>

# switch repo for usage in China
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# build minimized
RUN apk update && \
	apk add git g++ build-base linux-headers cmake && \
	apk add curl yaml-cpp libevent && \
    apk add curl-dev rapidjson-dev libevent-dev pcre-dev yaml-cpp-dev && \
    apk add libressl-dev  && \
    git clone https://github.com/tindy2013/subconverter
	
RUN cd subconverter && \
    cmake . && \
    make -j4 && \
    mv subconverter base/ && \
    
    apk del git gcc g++ build-base linux-headers cmake libressl-dev curl-dev rapidjson-dev libevent-dev yaml-cpp-dev

# set entry
CMD /subconverter/base/subconverter
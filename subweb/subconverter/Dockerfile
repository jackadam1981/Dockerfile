FROM alpine:3.15
MAINTAINER Tindy X <tindy.it@gmail.com>

# build minimized
RUN apk add git g++ build-base linux-headers cmake
RUN apk add libressl-dev
RUN apk add curl-dev rapidjson-dev libevent-dev pcre-dev yaml-cpp-dev
RUN git clone https://github.com/tindy2013/subconverter && \
    cd subconverter && \
    cmake . && \
    make -j4 && \
    mv subconverter base/ && \
    apk add curl yaml-cpp libevent && \
    apk del git gcc g++ build-base linux-headers cmake libressl-dev curl-dev rapidjson-dev libevent-dev yaml-cpp-dev

# set entry
CMD /subconverter/base/subconverter
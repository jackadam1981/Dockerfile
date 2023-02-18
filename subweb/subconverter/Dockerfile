FROM alpine:3.15
MAINTAINER Tindy X <tindy.it@gmail.com>

# build minimized
RUN apk add git g++ build-base linux-headers cmake
RUN apk add libressl-dev
RUN apk add curl-dev rapidjson-dev libevent-dev pcre-dev yaml-cpp-dev
RUN git clone https://github.com/tindy2013/subconverter
RUN cd subconverter
RUN cmake .
RUN make -j4
RUN mv subconverter base/
RUN apk add curl yaml-cpp libevent
RUN apk del git gcc g++ build-base linux-headers cmake libressl-dev curl-dev rapidjson-dev libevent-dev yaml-cpp-dev

# set entry
CMD /subconverter/base/subconverter
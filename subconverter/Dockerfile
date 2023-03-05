FROM alpine
MAINTAINER Tindy X <tindy.it@gmail.com>

ENV platforms=a
ENV armv7_palt=armv7
ENV linux64_palt=linux64
ENV base_uri=https://api.github.com/repos/tindy2013/subconverter/releases
ENV down_uri=https://github.com/tindy2013/subconverter/releases/download
ENV VER=0.7.2
ENV trueVER=v0.7.2
ENV down_url=https://github.com/tindy2013/subconverter/releases/download/v0.7.2/subconverter_linux64.tar.gz
ENV filename=subconverter_linux64.tar.gz

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk add curl jq
RUN get_arch=`arch` && \
	echo $get_arch && \
	if [[ $get_arch = "armv7l" ]];then platforms=$armv7_palt;else echo Bad; fi && \
	if [[ $get_arch = "x86_64" ]];then platforms="$linux64_palt";else echo Bad; fi && \
	echo $platforms  && \
	VER=$(curl -s $base_uri | jq 'first(.[].tag_name)') && \
	trueVER=${VER//\"/} && \
	echo $trueVER  && \
	down_url=${down_uri}/${trueVER}/subconverter_${platforms}.tar.gz && \
	filename=subconverter_${platforms}.tar.gz && \
	echo 🔎download: $down_url && \
	echo 🔎filename:$filename
RUN	echo "curl -L -o $filename $down_url"  && \
	curl -o $filename $down_url && \
	tar -zxvf ${filename} -C /
	
CMD  /subconverter/base/subconverter
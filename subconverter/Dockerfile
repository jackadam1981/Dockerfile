FROM alpine
MAINTAINER Tindy X <tindy.it@gmail.com>

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk add curl jq
RUN get_arch=`arch` && \
	echo $get_arch && \
	if [[ $get_arch = "armv7l" ]];then platforms="armv7"; fi && \
	if [[ $get_arch = "x86_64" ]];then platforms="linux64"; fi && \
	echo 目标：$platforms  && \
	base_uri=https://api.github.com/repos/tindy2013/subconverter/releases && \
	down_uri=https://github.com/tindy2013/subconverter/releases/download && \
	VER=$(curl -s $base_uri | jq 'first(.[].tag_name)') && \
	trueVER=${VER//\"/} && \
	down_url=${down_uri}/${trueVER}/subconverter_${platforms}.tar.gz && \
	filename=subconverter_${platforms}.tar.gz && \
	echo 🔎download: $down_url && \
	echo 🔎filename:$filename && \
	curl -L -o $filename $down_url && \
	tar -zxvf ${filename} -C /
	
CMD  /subconverter/base/subconverter
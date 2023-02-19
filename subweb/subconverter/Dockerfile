FROM alpine
MAINTAINER Tindy X <tindy.it@gmail.com>

RUN apk update && apk add curl jq
RUN get_arch=`arch` && \
	echo $get_arch && \
	if [[ $get_arch = "armv7l" ]];then platforms="armv7";else echo Bad; fi && \
	if [[ $get_arch = "x86_64" ]];then platforms="linux64";else echo Bad; fi && \
	echo $platforms && \
	base_uri=https://api.github.com/repos/tindy2013/subconverter/releases && \
	down_uri=https://github.com/tindy2013/subconverter/releases/download && \
	VER=$(curl -s $base_uri | jq 'first(.[].tag_name)') && \
	trueVER=${VER//\"/} && \
	echo $trueVER && \
	down_url=${down_uri}/${trueVER}/subconverter_${platforms}.tar.gz && \
	filename=subconverter_${platforms}.tar.gz && \
	echo $down_url && \
	echo $filename && \
	curl -O $down_uri  && \
	tar -zxvf $filename -C /
	
CMD  /subconverter/base/subconverter
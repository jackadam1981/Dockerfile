FROM alpine:3.12
MAINTAINER Tindy X <tindy.it@gmail.com>

RUN get_arch=`arch` && \
	echo $get_arch && \
	if [[ $get_arch =~ "armv7l" ]];then platforms="armv7";elif [[ $get_arch =~ "x86_64" ]];then platforms="linux64";else echo Bad; fi && \
	echo $platforms
	
CMD  /subconverter/base/subconverter
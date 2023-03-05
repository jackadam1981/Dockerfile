FROM alpine:latest

RUN apt add curl jq && \
	VER=$(curl -s https://api.github.com/repos/tindy2013/subconverter/releases/latest | grep tag_name | cut -d '"' -f 4) && \
	URL=$(curl -s https://api.github.com/repos/tindy2013/subconverter/releases/tags/${VER} | jq .assets[0].browser_download_url | tr -d \") && \
	echo $VER $URL

#CMD /subconverter/base/subconverter
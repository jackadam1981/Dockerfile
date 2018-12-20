#!/bin/sh
if [[ ! -e /v2ray ]]
then mkdir /v2ray
fi
if [[ ! -e /v2ray/v2ray ]]
then
	echo $VER
	if [[ "$VER" = 'none' ]] 
		then
		echo 'No specified version, automatically get the latest version.'
		VER=$(curl -s https://api.github.com/repos/v2ray/v2ray-core/releases | jq -r '.[0]'| grep tag_name | cut -d '"' -f 4)
		echo "Latest version is $VER"
	else
		echo "Specified version is $VER"
	fi
	echo "Get version $VER download address"
	URL=$(curl -s https://api.github.com/repos/v2ray/v2ray-core/releases/tags/${VER} | jq .assets[].browser_download_url |grep linux-64 | tr -d \")
	echo "print  URL: "
	echo $RUL
	echo "end print"
	#检查文件后缀名，去除多余的dgst
	check=${URL##*.}
	if check='dgst'
		then
		URL=${URL%.*}
	fi
	echo "Install version $VER，URL: $URL"
	cd /v2ray
	rm v2ray-linux-64.zip
	wget --no-check-certificate $URL
	unzip v2ray-linux-64.zip 
	chmod +x v2ray v2ctl
	echo 'Install over.'
else
echo 'Already installed.'
fi
cd /v2ray
echo -e "$CONFIG_JSON" > config.json
echo 'reday start'
if [[ "$UUID" = 'none' ]] 
then
	UUID=$(cat /proc/sys/kernel/random/uuid)
fi
sed -i  's/\("id": "\).*/\1'"$UUID"'",/g'   /v2ray/vpoint_vmess_freedom.json
echo 'allreday set uuid'
echo 'UUID: '$UUID
./v2ray -config /v2ray/vpoint_vmess_freedom.json
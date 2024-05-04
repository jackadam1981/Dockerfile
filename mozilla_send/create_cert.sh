#!/bin/bash
#国家代码（2位大写）
C=CN
#省份区域代码
ST=HeNan
#城市名称
L=ZhengZhhou
#组织名称
O=FreeNet
#组织单位名称
OU=CA
#CA证书持有者
RootCA_CN="Private RootCA"
#PowerCA证书持有者
PowerCA_CN="Private PowerCA"
#服务器证书持有者
SERVERCN=192.168.2.22
#管理员邮箱
Email=admin@example.com
#证书时效（年）
year=10


Base_PATH="./certificate"
Conf_Path="./cert_conf"
RootCA_Conf="$Conf_Path/RootCA.conf"
PowerCA_Conf="$Conf_Path/PowerCA.conf"
Server_conf="$Conf_Path/Server.conf"
Server_ext="$Conf_Path/Server.ext"
Client_conf="$Conf_Path/Client.conf"
RootCA_PATH="./RootCA"
RootCA_KEY="$RootCA_PATH/RootCA.key"
RootCA_cert="$RootCA_PATH/RootCA.crt"
RootCA_chain="$RootCA_PATH/RootCA_chain.crt"
RootCA_p12="$RootCA_PATH/RootCA_Chain.p12"
PowerCA_PATH="./PowerCA"
PowerCA_KEY="$PowerCA_PATH/PowerCA.key"
PowerCA_CSR="$PowerCA_PATH/PowerCA.csr"
PowerCA_cert="$PowerCA_PATH/PowerCA.crt"
PowerCA_chain="$PowerCA_PATH/PowerCAChain.crt"
PowerCA_p12="$PowerCA_PATH/PowerCAChain.p12"
Server_PATH="$Base_PATH/Server"
Server_KEY="$Server_PATH/$SERVERCN.key"
Server_CSR="$Server_PATH/$SERVERCN.csr"
Server_cert="$Server_PATH/$SERVERCN.crt"

Client_PATH="$Base_PATH/Client"

# 查看证书请求
# openssl req -noout -text -in test.csr 
# 查看证书
# openssl x509 -text -noout -in test.crt

function check_path(){
	if [ -d $1 ]; then
		rm -rf $1
    fi
	mkdir -p $1
}

function Create_RootCA_PEM() {
    echo "生成CA私钥"
    openssl genpkey \
        -algorithm ec \
        -pkeyopt ec_paramgen_curve:P-256 \
        -out $RootCA_KEY


    echo "生成CA证书(x509)"
    openssl req \
        -new \
        -x509 \
        -days $((365 * year)) \
        -config $RootCA_Conf \
        -key $RootCA_KEY \
        -out $RootCA_cert \
        -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${RootCA_CN}/emailAddress=${Email}"
		
		

	echo "验证CA证书"
    openssl  x509 -noout -text -in $RootCA_cert >/dev/null 2>&1
    [[ $? -ne 0 ]] && echo "ERROR: 读取CA证书出错" && exit 1
	
	
	# echo "读取展示CA证书"
    # openssl  x509 -noout -text -in $RootCA_cert

    echo "证书安全设置"
    echo "设置CA私钥的安全权限"
    chown root:root $RootCA_KEY
    chmod 600 $RootCA_KEY

    echo "备份CA私钥、证书"

    current_datetime=$(date +'%Y-%m-%d_%H:%M:%S')
	
	check_path $RootCA_PATH/back_${current_datetime}

    cp $RootCA_KEY $RootCA_PATH/back_${current_datetime}/RootCA.key
    cp $RootCA_cert $RootCA_PATH/back_${current_datetime}/RootCA.crt
    cp $RootCA_KEY ./RootCA_back_${current_datetime}.key
    cp $RootCA_cert ./RootCA_back_${current_datetime}.crt

}

function Create_PowerCA_PEM() {

    echo "生成PowerCA私钥"
    openssl genpkey \
        -algorithm ec \
        -pkeyopt ec_paramgen_curve:P-256 \
        -out $PowerCA_KEY


    echo "生成PowerCA证书请求"
	openssl req \
		-new \
		-config $PowerCA_Conf \
		-sha512 \
		-key $PowerCA_KEY \
		-out $PowerCA_CSR \
		-subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${PowerCA_CN}/emailAddress=${Email}"
	
	echo "CA签名中间证书"
	read -p "交互生成，请注意选y" 
	openssl ca \
		-config $RootCA_Conf \
		-extensions v3_intermediate_ca \
		-days $((365 * year)) \
		-notext \
		-md sha256 \
		-in $PowerCA_CSR \
		-out $PowerCA_cert \
		-subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${PowerCA_CN}/emailAddress=${Email}"
		
	echo "创建证书链"
	cat $PowerCA_cert \
		$RootCA_cert > $PowerCA_chain
	  
	echo "转换P12，Windows双击导入证书，提示输入密码，可以为空。"
	openssl pkcs12 -export \
		-name "powerca chain" \
		-inkey $PowerCA_KEY \
		-in $PowerCA_cert \
		-certfile $PowerCA_chain \
		-out $PowerCA_p12
}

function Create_Server_PEM() {
    echo "生成server私钥"
	check_path $Server_PATH
    openssl genpkey \
        -algorithm ec \
        -pkeyopt ec_paramgen_curve:P-256 \
        -out $Server_PATH/$SERVERCN.key

    echo "生成server san 证书请求"
    openssl req \
        -new \
        -key $Server_PATH/$SERVERCN.key \
        -out $Server_PATH/$SERVERCN.csr \
		-config $Server_conf \
        -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${SERVERCN}/emailAddress=${Email}"

	
	echo "CA x509签发server san证书"
	openssl x509 \
		-req \
		-in $Server_PATH/$SERVERCN.csr \
		-CA $RootCA_cert \
		-CAkey $RootCA_KEY \
		-out $Server_PATH/${SERVERCN}.crt \
		-CAcreateserial \
		-days $((365 * year)) \
		-sha256 \
		-extfile $Conf_Path/Server.ext \
		-subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${SERVERCN}/emailAddress=${Email}"
		

	# echo "用CA证书验证server证书"
    # openssl verify -CAfile ./CA/ca.crt ./certificate/server.crt >/dev/null 2>&1
    # [[ $? -ne 0 ]] && echo "ERROR: 无法根据CA证书验证server证书" && exit 1

}
Check_main_directory(){
	echo "更新配置文件中主目录路径"
	sed -i 's#^base_dir.*#base_dir = '"$PWD"'#g' $RootCA_Conf
	echo "检查所有目录基础文件"
	check_path $Base_PATH
	check_path $RootCA_PATH
	check_path $RootCA_PATH/crl
	check_path $RootCA_PATH/newcerts
	check_path $RootCA_PATH/db
	check_path $RootCA_PATH/private
	touch $RootCA_PATH/db/index
    openssl rand -hex 16 > $RootCA_PATH/db/serial
    echo 1001 > $RootCA_PATH/db/crlnumber
	check_path $PowerCA_PATH
	check_path $PowerCA_PATH/crl
	check_path $PowerCA_PATH/newcerts
	check_path $PowerCA_PATH/db
	check_path $PowerCA_PATH/private
	touch $PowerCA_PATH/db/index
    openssl rand -hex 16 > $PowerCA_PATH/db/serial
    echo 1001 > $PowerCA_PATH/db/crlnumber
	
}


function update_templates(){
	sed -i 's#^.*ssl_certificate /etc/nginx/certificate/.*#		ssl_certificate /etc/nginx/certificate/'"$SERVERCN"'.crt;#g' templates/send.conf.template
	sed -i 's#^.*ssl_certificate_key /etc/nginx/certificate/.*#		ssl_certificate_key /etc/nginx/certificate/'"$SERVERCN"'.key;#g' templates/send.conf.template
}

function main() {
	
    read -p "是否生成根CA证书，如果不生成，将使用上次生成的CA证书。直接回车，默认不生成。y/n?:" isCA
    : ${isCA:="n"}
    if [ $isCA = "y" ]; then
		Check_main_directory
        Create_RootCA_PEM
		
    fi

	read -p "是否生成中间CA证书,直接回车，默认不生成。y/n?" isPowerCA
    : ${isPowerCA:="n"}
    if [ $isPowerCA = "y" ]; then
        Create_PowerCA_PEM
    fi
	
    read -p "是否生成服务器证书并CA签名,直接回车，默认不生成。y/n?" isServer
    : ${isServer:="n"}
    if [ $isServer = "y" ]; then
		update_templates
        Create_Server_PEM
    fi

}

main
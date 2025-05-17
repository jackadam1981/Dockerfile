#!/bin/bash

# 检查是否安装了expect
if ! command -v expect &> /dev/null; then
    echo "请先安装expect："
    echo "Ubuntu/Debian: sudo apt-get install expect"
    echo "CentOS/RHEL: sudo yum install expect"
    exit 1
fi

# 生成随机JWT密钥
jwt_key=$(openssl rand -base64 32)

echo "生成的JWT密钥: $jwt_key"

# 更新.env文件
if [ -f .env ]; then
    # 更新或添加JWT密钥
    if grep -q "JWT_KEY=" .env; then
        sed -i "/JWT_KEY=/c\JWT_KEY=$jwt_key" .env
    else
        echo "JWT_KEY=$jwt_key" >> .env
    fi
    
else
    # 创建新的.env文件
    echo "JWT_KEY=$jwt_key" > .env
fi

echo "JWT密钥信息已更新到.env文件" 
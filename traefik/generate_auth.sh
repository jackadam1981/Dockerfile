#!/bin/bash

# 提示输入用户名
read -p "请输入Dashboard用户名: " username

# 提示输入密码（不显示输入）
read -s -p "请输入Dashboard密码: " password
echo

# 使用htpasswd生成认证信息
auth_info=$(docker run --rm -it --entrypoint /usr/local/apache2/bin/htpasswd httpd:alpine -nb $username $password)

# 转义所有美元符号，每个$变成$$
auth_info=$(echo "$auth_info" | sed -e 's/\$/\\$\\$/g')

echo "生成的认证信息: $auth_info"

# 处理.env文件
if [ -f .env ]; then
    # 更新或添加认证信息
    if grep -q "DASHBOARD_AUTH=" .env; then
        sed -i "/DASHBOARD_AUTH=/c\DASHBOARD_AUTH=$auth_info" .env
    else
        echo "DASHBOARD_AUTH=$auth_info" >> .env
    fi
else
    # 创建新的.env文件
    echo "DASHBOARD_AUTH=$auth_info" > .env
fi

echo "认证信息已更新到.env文件"
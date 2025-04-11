#!/bin/bash

# 检查是否安装了expect
if ! command -v expect &> /dev/null; then
    echo "请先安装expect："
    echo "Ubuntu/Debian: sudo apt-get install expect"
    echo "CentOS/RHEL: sudo yum install expect"
    exit 1
fi

# 生成随机密码
password=$(openssl rand -base64 12)

echo "生成的管理员密码: $password"
echo "请使用此密码登录网页管理界面"

# 使用expect自动交互生成令牌
max_retries=3
retry_count=0
while [ $retry_count -lt $max_retries ]; do
    echo "尝试生成令牌 (第 $((retry_count + 1)) 次)..."
    
    expect_output=$(expect -c "
spawn docker run --rm -it vaultwarden/server /vaultwarden hash
expect \"Password:\"
send \"$password\r\"
expect \"Confirm password:\"
send \"$password\r\"
expect eof
")

    # 检查是否成功生成令牌
    if echo "$expect_output" | grep -q "ADMIN_TOKEN="; then
        break
    fi
    
    retry_count=$((retry_count + 1))
    if [ $retry_count -lt $max_retries ]; then
        echo "生成令牌失败，等待 5 秒后重试..."
        sleep 5
    fi
done

# 检查是否成功生成令牌
if [ $retry_count -eq $max_retries ]; then
    echo "错误：无法生成令牌，请稍后再试"
    exit 1
fi

# 提取完整的ADMIN_TOKEN行
new_token_line=$(echo "$expect_output" | grep "ADMIN_TOKEN=")

echo "生成的管理员令牌: $new_token_line"
echo "此令牌用于API访问，请妥善保管"

# 更新.env文件
if [ -f .env ]; then
    # 更新或添加管理员密码
    if grep -q "ADMIN_PASSWORD=" .env; then
        sed -i "/ADMIN_PASSWORD=/c\ADMIN_PASSWORD=$password" .env
    else
        echo "ADMIN_PASSWORD=$password" >> .env
    fi
    
    # 更新或添加管理员令牌
    if grep -q "ADMIN_TOKEN=" .env; then
        sed -i "/ADMIN_TOKEN=/c\\$new_token_line" .env
    else
        echo "$new_token_line" >> .env
    fi
else
    # 创建新的.env文件
    echo "ADMIN_PASSWORD=$password" > .env
    echo "$new_token_line" >> .env
fi

# 更新docker-compose.yaml文件中的令牌
if [ -f docker-compose.yaml ]; then
    # 提取令牌值（去掉ADMIN_TOKEN=前缀）
    token_value=$(echo "$new_token_line" | cut -d'=' -f2)
    # 更新docker-compose.yaml中的令牌
    sed -i "/ADMIN_TOKEN:/c\          ADMIN_TOKEN: $token_value" docker-compose.yaml
    echo "docker-compose.yaml文件已更新"
else
    echo "错误：找不到docker-compose.yaml文件"
fi

echo "管理员密码和令牌已更新到.env文件"
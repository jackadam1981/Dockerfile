
# RustDesk Server 部署指南

这是一个基于Docker的RustDesk自托管服务器解决方案，支持通过Traefik或Nginx进行反向代理和SSL终止。

使用[lejianwen/rustdesk-api: Custom Rustdesk Api Server, include web admin ,web client, web client v2 preview and oidc login](https://github.com/lejianwen/rustdesk-api)

更多设置，请看[lejianwen/rustdesk-api](https://github.com/lejianwen/rustdesk-api)

## 架构说明

本部署包含以下组件：* RustDesk API服务 (端口21114)

* RustDesk ID服务 (端口21118，WebSocket)
* RustDesk Relay服务 (端口21116/21117/21119，含WebSocket)
* Traefik或Nginx反向代理，提供SSL终止

## 快速开始

### 准备工作

1. 确保已安装Docker和Docker Compose
2. 生成JWT密钥：

   `./generate_jwt.sh`

### 使用Traefik部署（推荐）

1. 设置环境变量（可复制.env.example文件）：

   ```
   # Domain Configuration
   DOMAIN=rustdesk.yourdomain.com

   # ports set
   # API 
   TRAEFIK_PORT=18443
   NGINX_PORT=18444
   # ID
   ID_PORT=21116
   RELAY_PORT=21117

   # RustDesk Configuration
   API_SERVER=https://rustdesk.yourdomain.com
   ID_SERVER=rustdesk.yourdomain.com
   RELAY_SERVER=rustdesk.yourdomain.com

   # JWT Configuration
   JWT_KEY=39jAU%GrJ5r8Db

   # Other Settings
   ENCRYPTED_ONLY=1
   MUST_LOGIN=N
   TZ=Asia/Shanghai 

   # 网络配置 请看traefik目录
   NETWORK_NAME=v6net

   # 证书管理器 请看traefik目录
   CERTIFICATE_MANAGER=myresolver
   ```
2. 启动服务：

   `docker-compose up -d`

### 使用Nginx部署（备选方案）

1. 准备SSL证书，放入./ssl/rustdesk.yourdomain.com/目录
2. 修改conf.d/default.conf中的域名
3. 启动服务：

   `docker-compose -f docker-compose_nginx.yaml up -d`

## 目录结构

* conf.d/ - Nginx配置文件
* ssl/ - SSL证书存放目录
* data/ - 数据持久化目录
* data/server/ - RustDesk服务器数据
* data/api/ - RustDesk API数据
* generate_jwt.sh - JWT密钥生成脚本

## 端口说明

* 21114: API服务
* 21115: Relay TCP
* 21116: Relay TCP/UDP
* 21117: Relay TCP
* 21118: ID服务WebSocket
* 21119: Relay WebSocket

## 客户端配置

在RustDesk客户端中，使用以下服务器设置：

* ID服务器: rustdesk.yourdomain.com
* 中继服务器: rustdesk.yourdomain.com
* key：rustdesk\data\server\id_ed25519.pub 文件中的字符串

## 故障排除

如遇连接问题，请检查：1. WebSocket路径配置是否正确（/ws/id和/ws/relay）

1. SSL证书是否有效
2. 防火墙是否允许所需端口通行
3. 环境变量配置是否正确

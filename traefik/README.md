# Traefik

新一代的反代管理工具，支持acme申请证书。

也是用erpnext时发现erpnext使用这个反代，就顺手用起来了。


由于自动申请acme证书，要进行域名挑战，所以我根据我的习惯，配置了cloudflare的DNS挑战。

## 创建token

创建的api token 创建地址为：https://dash.cloudflare.com/profile/api-tokens

要求创建DNS编辑权限，可以只选一个域，也可以选择所有域。

## 创建用户密码

可以通过脚本generate_auth.sh

使用一个docker容器来创建加密的密码，并自动更新.env文件。

## ENABLE_INSECURE_API

[接口] 不安全 = true 这意味着 API 在入口点 traefik（端口 8080）上公开 [接口] 不安全 = false 这意味着 API 在入口点上根本不公开。因此，您需要创建一个使用 api@internal 服务访问 API 的路由器 如果您使用的是 api@interna...

说实话，我也没搞懂

## IPV6

使用首页的命令生成支持IPV6的docker 网络，才可以ipv6访问。

## 证书管理器名称

这个其他docker compose要用的。

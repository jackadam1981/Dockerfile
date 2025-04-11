
# DockerFile

本仓库为本人经常使用的DockerFile  docker-compose.yaml

家庭服务器折腾，所以只有IPv6公网，为了安全，还要ssl证书，最终使用traefik作为反代。

## IPv6

以前是这么干的

[docker compose ipv6的处理 容器互联的方法 - 上官飞鸿 - 博客园](https://www.cnblogs.com/jackadam/p/16617369.html)

现在似乎方便了。

Client: Docker Engine - Community
 Version:    28.0.4

手动创建一个支持v6的网络v6net

```
 docker network create --ipv6 v6net
```

测试ipv6网络，可以使用test_ipv6.yaml

```
services:
  busybox:
    image: busybox
    command: ping6 -c 4 music.163.com

networks:
  default:
    external: true
    name: v6net

```

手动运行该容器测试

```
root@onecloud:/storage/build# docker compose -f test_ipv6.yaml up
[+] Running 1/1
 ✔ Container build-busybox-1  Recreated                                                                                                                                                                                                 0.2s
Attaching to busybox-1
busybox-1  | PING music.163.com (240e:938:a07:6:0:4:0:1): 56 data bytes
busybox-1  | 64 bytes from 240e:938:a07:6:0:4:0:1: seq=0 ttl=50 time=35.485 ms
busybox-1  | 64 bytes from 240e:938:a07:6:0:4:0:1: seq=1 ttl=50 time=34.859 ms
busybox-1  | 64 bytes from 240e:938:a07:6:0:4:0:1: seq=2 ttl=50 time=34.087 ms
busybox-1  | 64 bytes from 240e:938:a07:6:0:4:0:1: seq=3 ttl=50 time=33.548 ms
busybox-1  |
busybox-1  | --- music.163.com ping statistics ---
busybox-1  | 4 packets transmitted, 4 packets received, 0% packet loss
busybox-1  | round-trip min/avg/max = 33.548/34.494/35.485 ms
busybox-1 exited with code 0

```

## 各个服务目录

点进各个服务目录，一般会有单独的readme。介绍怎么使用。

一般会提供.env.example，复制为.env，编辑后再启动即可。

docker compose up -d

| 序号 | 名称    | 简介                                                      |
| ---- | ------- | --------------------------------------------------------- |
| 1    | traefik | 反向代理服务，自带acme，配置cloudflaer dns挑战，替代nginx |
|      |         |                                                           |

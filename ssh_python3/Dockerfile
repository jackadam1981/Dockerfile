from alpine:3.8
MAINTAINER jackadam<jackadam@sina.com>
#变更源
# 安装包源切到中科大, 国内访问加速
RUN { \
        echo 'http://mirrors.ustc.edu.cn/alpine/v3.8/main'; \
        echo 'http://mirrors.ustc.edu.cn/alpine/v3.8/community'; \
        echo 'http://mirrors.ustc.edu.cn/alpine/edge/main'; \
        echo 'http://mirrors.ustc.edu.cn/alpine/edge/community'; \
        echo 'http://mirrors.ustc.edu.cn/alpine/edge/testing'; \
    } > /etc/apk/repositories

# 设置默认时区为亚洲/上海 (没有北京可选)
RUN apk upgrade   && \
    apk add --no-cache apk-tools tzdata openssh && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del tzdata  && \
#修改root密码
    echo root:123456 | chpasswd  && \
#生成KEY
    ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -P '' -N '' && \
#允许远程登录
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
    
#这里增加python3
RUN apk add python3 sudo &&\
    pip3 install -i http://pypi.douban.com/simple  --upgrade   --trusted-host pypi.douban.com  pip setuptools 


#开放22端口
EXPOSE 22

CMD /usr/sbin/sshd -D
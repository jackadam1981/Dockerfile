FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine
RUN sed -i 's/#//g' /etc/apk/repositories && \
	apk add --no-cache apk-tools tzdata xvfb sudo chromium chromium-chromedriver && \
	pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip && \
    pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade setuptools && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del tzdata
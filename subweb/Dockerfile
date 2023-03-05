FROM node:14-alpine AS build
LABEL maintainer="Stille <stille@ioiox.com>"

RUN apk add --update git
RUN git clone https://github.com/stilleshan/subweb /app
WORKDIR /app
RUN npm cache clean -f
RUN npm install -g n 
RUN npm install -g n --force
RUN npm config get registry
RUN npm config set registry https://registry.npm.taobao.org
RUN npm config get registry
RUN npm install
RUN npm run build

FROM nginx:1.16-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY . /app
EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
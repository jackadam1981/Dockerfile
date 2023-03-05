FROM node:14-alpine AS build
LABEL maintainer="Stille <stille@ioiox.com>"

RUN apk add --update git
RUN git clone https://github.com/stilleshan/subweb /app
WORKDIR /app
RUN npm install
RUN npm run build


FROM nginx:1.16-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/start.sh /app/start.sh
RUN cd /app && ls -lh
RUN sed -i "/ listen 80;/a\ listen [::]:80;" /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
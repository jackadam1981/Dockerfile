FROM alpine

RUN apk add --no-cache samba-common-tools samba-server
RUN echo $'[global]\n\
netbios name = Samba\n\
workgroup = WORKGROUP\n\
server string = Samba Server\n\
map to guest = bad user\n\
[share]\n\
path = /share\n\
public = yes \n\
writable = yes\n\
create mask = 0765\n'\
>> /etc/samba/smb.conf
VOLUME /etc/samba \
       /var/lib/samba
EXPOSE 137/udp \
       138/udp \
       139/tcp \
       445/tcp
CMD nmbd -D && smbd -D
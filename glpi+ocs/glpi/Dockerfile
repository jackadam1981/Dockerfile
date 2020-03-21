#On choisit une debian
FROM debian:latest

MAINTAINER DiouxX "github@diouxx.be"

#Ne pas poser de question à l'installation
ENV DEBIAN_FRONTEND noninteractive

#Installation d'apache et de php5 avec extension
RUN apt update \
&& apt -y upgrade \
&& apt -y install \
apache2 \
php \
php-mysql \
php-ldap \
php-xmlrpc \
php-imap \
curl \
php-curl \
php-gd \
php-mbstring \
php-xml \
php-apcu-bc \
php-cas \
cron \
wget \
jq \
snmpd

#Copie et execution du script pour l'installation et l'initialisation de GLPI
COPY glpi-start.sh /opt/
COPY glpi-9.4.5.tgz /tmp/
COPY glpi-ocsinventoryng-1.6.0.tar.gz /tmp/
RUN chmod +x /opt/glpi-start.sh
ENTRYPOINT ["/opt/glpi-start.sh"]

#Exposition des ports
EXPOSE 80 443
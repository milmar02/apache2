FROM alpine:latest
LABEL maintainer="chriswood.ca@gmail.com,jesse@weisner.ca"
LABEL alpine_version="3.10"
LABEL httpd_version="2.4.41"
LABEL httpd_apk_release="0"
LABEL build_id="1568848088"

ENV RUNUSER apache

COPY httpd-foreground /usr/local/bin/httpd-foreground
COPY httpd.conf /etc/apache2/httpd.conf
COPY 50-copy-config.sh /docker-entrypoint.d/50-copy-config.sh


RUN apk --no-cache add \
    libcap \
    apache2 \
	unzip \
	openssl \
	wget
RUN apk add --no-cache  --repository http://dl-cdn.alpinelinux.org/alpine/latest-stable/community php7 php7-common php7-curl php7-gd php7-imap php7-intl php7-json php7-ldap php7-mbstring php7-mysqli php7-pgsql php7-sqlite3 php7-xml php7-zip php7-pecl-ssh2 php7-pecl-imagick php7-apache2 php7-pecl-mcrypt php7-mysqlnd php7-pdo_mysql php7-session php7-xmlreader php7-simplexml
RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/httpd 
RUN mkdir /etc/apache2/vhost.d /config /application

RUN wget https://downloads.joomla.org/cms/joomla3/3-9-28/Joomla_3-9-28-Stable-Full_Package.zip
RUN mkdir /application/joomla
RUN unzip Joomla_3-9-28-Stable-Full_Package.zip -d /application/joomla

COPY info.php /application/joomla/info.php
COPY php.ini /etc/php7/php.ini
RUN mkdir /var/log/apache
 
RUN chown 0:0 /etc/apache2/vhost.d /config /run/apache2 /var/log/apache2 /application /var/log/apache/
RUN chmod 775 /etc/apache2/vhost.d /config /run/apache2 /var/log/apache2 /application /var/log/apache/
RUN chmod 755 /usr/local/bin/httpd-foreground

EXPOSE 80
# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL WINCH

CMD ["/usr/local/bin/httpd-foreground"]

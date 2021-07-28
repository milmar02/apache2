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
 && setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/httpd \
 && mkdir /etc/apache2/vhost.d /config /application \
 && chown 0:0 /etc/apache2/vhost.d /config /run/apache2 /var/log/apache2 /application \
 && chmod 775 /etc/apache2/vhost.d /config /run/apache2 /var/log/apache2 /application \
 && chmod 755 /usr/local/bin/httpd-foreground

EXPOSE 80
# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL WINCH

CMD ["/usr/local/bin/httpd-foreground"]

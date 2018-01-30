FROM ubuntu:14.04
MAINTAINER Cedric Gatay <c.gatay@code-troopers.com>

RUN apt-get update && \
    apt-get install -y apache2 curl unzip && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2enmod ssl 

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

COPY vhosts/default.conf /etc/apache2/sites-enabled/
COPY certs/ /etc/apache2/ssl/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 443

CMD /usr/sbin/apache2ctl -D FOREGROUND

FROM wodby/httpd:2.4.26

ENV GOTPL_VER 0.1.5
ENV GOTPL_URL https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz
ENV HTML_DIR /var/www/html
ENV APACHE_DIR /usr/local/apache2

RUN set -ex && \

    apk --update add \
        bash \
        ca-certificates \
        curl \
        make \
        su-exec \
        wget && \

    wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin && \
    mkdir -p /usr/local/apache2/conf/conf.d

COPY actions /usr/local/bin

WORKDIR $HTML_DIR

COPY templates/* /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["httpd-foreground"]

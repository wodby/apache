ARG HTTPD_VER

FROM wodby/httpd:${HTTPD_VER}

ARG HTTPD_VER

ENV HTTPD_VER="${HTTPD_VER}" \
    HTML_DIR="/var/www/html" \
    APACHE_DIR="/usr/local/apache2"

RUN set -ex; \
    \
    deluser www-data; \
    addgroup -S apache; \
    adduser -S -D -H -h /usr/local/apache2 -s sbin/nologin -G apache apache; \
    \
    apk --update --no-cache -t .apache-rundeps add \
        make \
        sudo; \
    \
    mkdir -p "${HTML_DIR}" /usr/local/apache2/conf/conf.d; \
    chown -R apache:apache "${HTML_DIR}" /usr/local/apache2; \
    rm -f /usr/local/apache2/logs/httpd.pid; \
    \
    echo 'apache ALL=(root) NOPASSWD: /usr/local/apache2/bin/httpd' > /etc/sudoers.d/apache; \
    \
    # Cleanup
    rm -rf /var/cache/apk/*

USER apache

WORKDIR $HTML_DIR

COPY actions /usr/local/bin
COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "httpd", "-DFOREGROUND"]

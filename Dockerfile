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
    adduser -S -D -H -h /usr/local/apache2 -s /bin/bash -G apache apache; \
    \
    apk --update --no-cache -t .apache-rundeps add \
        make \
        sudo; \
    \
    mkdir -p /usr/local/apache2/conf/conf.d; \
    chown -R apache:apache /usr/local/apache2; \
    rm -f /usr/local/apache2/logs/httpd.pid; \
    \
    # Script to fix volumes permissions via sudo.
    echo "chown apache:apache ${HTML_DIR}" > /usr/local/bin/fix-volumes-permissions.sh; \
    chmod +x /usr/local/bin/fix-volumes-permissions.sh; \
    \
    # Configure sudoers
    { \
        echo -n 'apache ALL=(root) NOPASSWD: ' ; \
        echo -n '/usr/local/bin/fix-volumes-permissions.sh, ' ; \
        echo '/usr/local/apache2/bin/httpd' ; \
    } | tee /etc/sudoers.d/apache; \
    \
    # Cleanup
    rm -rf /var/cache/apk/*

USER apache

COPY actions /usr/local/bin

WORKDIR $HTML_DIR

COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "httpd", "-DFOREGROUND"]

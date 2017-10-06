ARG HTTPD_VER

FROM wodby/httpd:${HTTPD_VER}

ARG HTTPD_VER

ENV HTML_DIR="/var/www/html" \
    APACHE_DIR="/usr/local/apache2" \
    HTTPD_VER="${HTTPD_VER}"

RUN set -ex && \

    deluser www-data && \
    addgroup -g 82 -S www-data && \
    adduser -u 82 -D -S -s /bin/bash -G www-data www-data && \

    apk --update --no-cache add \
        make \
        sudo && \

    mkdir -p /usr/local/apache2/conf/conf.d && \
    chown -R www-data:www-data /usr/local/apache2 && \

    rm -f /usr/local/apache2/logs/httpd.pid && \

    # Configure sudoers
    { \
        echo -n 'www-data ALL=(root) NOPASSWD: ' ; \
        echo -n '/usr/local/bin/fix-permissions.sh, ' ; \
        echo '/usr/local/apache2/bin/httpd' ; \
    } | tee /etc/sudoers.d/www-data

USER www-data

COPY actions /usr/local/bin

WORKDIR $HTML_DIR

COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "httpd", "-DFOREGROUND"]

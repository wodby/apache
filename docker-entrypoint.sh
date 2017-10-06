#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

function exec_tpl {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

# 2.2 or 2.4
apache_ver="${HTTPD_VER:0:3}"

exec_tpl "${apache_ver}/httpd.conf.tpl"  "${APACHE_DIR}/conf/httpd.conf"
exec_tpl "${apache_ver}/settings.conf.tpl" "${APACHE_DIR}/conf/conf.d/settings.conf"

exec_tpl "vhost.conf.tpl" "${APACHE_DIR}/conf/conf.d/vhost.conf"
exec_tpl "healthz.conf.tpl" "${APACHE_DIR}/conf/healthz.conf"

sudo fix-permissions.sh www-data www-data "${HTML_DIR}"
exec-init-scripts.sh

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi

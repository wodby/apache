#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

_gotpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

process_templates() {
    _gotpl "httpd.conf.tpl"  "${APACHE_DIR}/conf/httpd.conf"
    _gotpl "vhost.conf.tpl" "${APACHE_DIR}/conf/conf.d/vhost.conf"
    _gotpl "healthz.conf.tpl" "${APACHE_DIR}/conf/healthz.conf"
}

sudo init_volumes

process_templates

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi

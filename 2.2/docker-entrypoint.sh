#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

function execTpl {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

function execInitScripts {
    shopt -s nullglob
    for f in /docker-entrypoint-init.d/*.sh; do
        echo "$0: running $f"
        . "$f"
    done
    shopt -u nullglob
}

fixPermissions() {
    chown www-data:www-data "${HTML_DIR}"
}

execTpl "httpd.conf.tpl"  "${APACHE_DIR}/conf/httpd.conf"
execTpl "settings.conf.tpl" "${APACHE_DIR}/conf/conf.d/settings.conf"

fixPermissions
execInitScripts

if [[ "${1}" == 'make' ]]; then
    su-exec www-data "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi

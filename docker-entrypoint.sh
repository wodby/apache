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

# Backwards compatibility for old env vars names.
_backwards_compatibility() {
    declare -A vars
    # vars[DEPRECATED]="ACTUAL"
    vars[APACHE_SERVER_ROOT]="APACHE_DOCUMENT_ROOT"

    for i in "${!vars[@]}"; do
        # Use value from old var if it's not empty and the new is.
        if [[ -n "${!i}" && -z "${!vars[$i]}" ]]; then
            export ${vars[$i]}="${!i}"
        fi
    done
}


process_templates() {
    _backwards_compatibility

    _gotpl "httpd.conf.tmpl"  "${APACHE_DIR}/conf/httpd.conf"
    _gotpl "vhost.conf.tmpl" "${APACHE_DIR}/conf/conf.d/vhost.conf"

    _gotpl "presets/${APACHE_VHOST_PRESET}.conf.tmpl" "${APACHE_DIR}/conf/preset.conf"
}

sudo init_volumes

process_templates

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi

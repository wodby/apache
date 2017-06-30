#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

make check-ready max_try=10 host=apache -f /usr/local/bin/actions.mk

echo -n "Checking Apache response... "
curl -s apache | grep -q "It works!"
echo "OK"

echo -n "Checking Apache version... "
httpd -v | grep -q "Server version: Apache\/2.4.*"
echo "OK"

httpd -M > /tmp/apache_modules
echo -n "Checking Apache modules... "

if ! cmp -s /tmp/apache_modules /tests/apache_modules; then
    echo "Error. Apache modules are not identical."
    diff /tmp/apache_modules /tests/apache_modules
    exit 1
fi

echo "OK"

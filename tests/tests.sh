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
httpd -v | grep -q "Server version: Apache\/${HTTPD_VER}"
echo "OK"

httpd -M > ~/apache_modules
echo -n "Checking Apache modules... "

cp /tests/apache_modules ~/expected_modules

if ! cmp -s ~/apache_modules ~/expected_modules; then
    echo "Error. Apache modules are not identical."
    diff ~/apache_modules ~/expected_modules
    exit 1
fi

echo "OK"

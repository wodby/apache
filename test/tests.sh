#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "It works!" > /var/www/html/index.html

echo -n "Checking Apache response... "
curl -s localhost | grep -q "It works!"
echo "OK"

rm /var/www/html/index.html

echo -n "Checking Apache version... "
httpd -v | grep -q "Server version: Apache\/${HTTPD_VER}"
echo "OK"

httpd -M > /tmp/apache_modules
echo -n "Checking Apache modules... "

if ! cmp -s /tmp/apache_modules /home/wodby/apache_modules; then
    echo "Error. Apache modules are not identical."
    diff /tmp/apache_modules /home/wodby/apache_modules
    exit 1
fi

echo "OK"

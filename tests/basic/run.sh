#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose up -d

run_action() {
    docker-compose exec -T "${1}" make "${@:2}" -f /usr/local/bin/actions.mk
}

run_action apache check-ready max_try=10

docker-compose exec -T apache tests.sh
docker-compose down

cid="$(docker run -d -e APACHE_HTTP2=1 --name "apache" "${IMAGE}")"
trap "docker rm -vf $cid > /dev/null" EXIT

docker run --rm -i -e DEBUG=1 -e apache_HTTP2=1 --link "apache":"apache" "${IMAGE}" make check-ready host=apache

#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

git_url=git@bitbucket.org:wodby/php-git-test.git

docker-compose -f test/docker-compose.yml up -d

docker_exec() {
    docker-compose -f test/docker-compose.yml exec "${@}"
}

run_action() {
    docker_exec "${1}" make "${@:2}" -f /usr/local/bin/actions.mk
}

run_action apache check-ready max_try=10

docker_exec apache tests.sh

# Git actions
echo -n "Running git actions... "
run_action apache git-clone url="${git_url}" branch=master
run_action apache git-checkout target=develop
echo "OK"

docker-compose -f test/docker-compose.yml down

cid="$(docker run -d -e APACHE_HTTP2=1 --name "apache" "${IMAGE}")"
trap "docker rm -vf $cid > /dev/null" EXIT

docker run --rm -i -e DEBUG=1 -e apache_HTTP2=1 --link "apache":"apache" "${IMAGE}" make check-ready host=apache
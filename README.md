# Apache HTTP Server Docker Container Image

[![Build Status](https://travis-ci.org/wodby/apache.svg?branch=master)](https://travis-ci.org/wodby/apache)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/apache.svg)](https://hub.docker.com/r/wodby/apache)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/apache.svg)](https://hub.docker.com/r/wodby/apache)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

* All images are based on Alpine Linux
* Base image: [wodby/httpd](https://github.com/wodby/httpd)
* [Travis CI builds](https://travis-ci.org/wodby/apache) 
* [Docker Hub](https://hub.docker.com/r/wodby/apache) 

For better reliability we release images with stability tags (`wodby/apache:2.4-X.X.X`) which correspond to git tags. We **strongly recommend** using images only with stability tags. Below listed basic tags:

| Image tag (Dockerfile)                                                 | Apache |
| ---------------------------------------------------------------------- | ------ |
| [2.4 (latest)](https://github.com/wodby/apache/tree/master/Dockerfile) | 2.4.29 |
| [2.2](https://github.com/wodby/apache/tree/master/Dockerfile)          | 2.2.34 |

## Environment Variables 

| Variable                           | Default Value                                | Description |
| ---------------------------------- | -------------------------------------------- | ----------- |
| APACHE_HOSTNAME_LOOKUPS            | Off                                          |             |
| APACHE_KEEP_ALIVE                  | On                                           |             |
| APACHE_KEEP_ALIVE_TIMEOUT          | 5                                            |             |
| APACHE_LOG_LEVEL                   | warn                                         |             |
| APACHE_ENABLE_HEALTHZ_LOGS         |                                              |             |
| APACHE_MAX_KEEP_ALIVE_REQUESTS     | 100                                          |             |
| APACHE_MPM_EVENT_SERVER_LIMIT      | 16                                           |             |
| APACHE_MPM_EVENT_MAX_CLIENTS       | 400                                          |             |
| APACHE_MPM_EVENT_START_SERVERS     | 3                                            |             |
| APACHE_MPM_EVENT_THREADS_PER_CHILD | 25                                           |             |
| APACHE_MPM_EVENT_THREAD_LIMIT      | 64                                           |             |
| APACHE_REQUEST_READ_TIMEOUT        | header=20-40,MinRate=500 body=20,MinRate=500 |             |
| APACHE_SERVER_NAME                 | default                                      |             |
| APACHE_SERVER_TOKENS               | Full                                         |             |
| APACHE_SERVER_SIGNATURE            | Off                                          |             |
| APACHE_TIMEOUT                     | 60                                           |             |
| APACHE_USE_CANONICAL_NAME          | Off                                          |             |

## Enabled Apache Modules

* [2.4](https://raw.githubusercontent.com/wodby/apache/master/tests/apache_modules_2.4)
* [2.2](https://raw.githubusercontent.com/wodby/apache/master/tests/apache_modules_2.2)

## Actions

Usage:
```
make COMMAND [params ...]

commands:
    check-ready [host max_try wait_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
```

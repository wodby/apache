# Apache HTTP server docker container image

[![Build Status](https://travis-ci.org/wodby/apache.svg?branch=master)](https://travis-ci.org/wodby/apache)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/apache.svg)](https://hub.docker.com/r/wodby/apache)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/apache.svg)](https://hub.docker.com/r/wodby/apache)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Supported tags and respective `Dockerfile` links

- [`2.4`, `latest` (*2.4/Dockerfile*)](https://github.com/wodby/apache/tree/master/2.4/Dockerfile)
- [`2.2`, (*2.2/Dockerfile*)](https://github.com/wodby/apache/tree/master/2.2/Dockerfile)

## Environment variables available for customization

| Environment Variable | Default Value | Description |
| -------------------- | ------------- | ----------- |
| APACHE_ACCESS_FILE_NAME        | .htaccess                                    | |
| APACHE_HOSTNAME_LOOKUPS        | Off                                          | |
| APACHE_KEEP_ALIVE              | On                                           | |
| APACHE_KEEP_ALIVE_TIMEOUT      | 5                                            | |
| APACHE_LOG_LEVEL               | warn                                         | |
| APACHE_MAX_KEEP_ALIVE_REQUESTS | 100                                          | |
| APACHE_REQUEST_READ_TIMEOUT    | header=20-40,MinRate=500 body=20,MinRate=500 | |
| APACHE_SERVER_TOKENS           | Full                                         | |
| APACHE_SERVER_SIGNATURE        | Off                                          | |
| APACHE_TIMEOUT                 | 60                                           | |
| APACHE_USE_CANONICAL_NAME      | Off                                          | |

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

## Deployment

Deploy Apache to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).

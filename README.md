# Apache HTTP server docker container image

[![Build Status](https://travis-ci.org/wodby/apache.svg?branch=master)](https://travis-ci.org/wodby/apache)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/apache.svg)](https://hub.docker.com/r/wodby/apache)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/apache.svg)](https://hub.docker.com/r/wodby/apache)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

Images are built via [Travis CI](https://travis-ci.org/wodby/php) and published on [Docker Hub](https://hub.docker.com/r/wodby/php). 

## Versions

| Apache version (link to Dockerfile) | Alpine Linux version |
| -------------------------------- | -------------------- |
| [2.2.32](https://github.com/wodby/php/tree/master/2.2/Dockerfile) | 3.4 |  
| [2.4.26](https://github.com/wodby/php/tree/master/2.4/Dockerfile) | 3.6 |  

## Environment Variables 

| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| APACHE_ACCESS_FILE_NAME            | .htaccess                                    | |
| APACHE_HOSTNAME_LOOKUPS            | Off                                          | |
| APACHE_KEEP_ALIVE                  | On                                           | |
| APACHE_KEEP_ALIVE_TIMEOUT          | 5                                            | |
| APACHE_LOG_LEVEL                   | warn                                         | |
| APACHE_MAX_KEEP_ALIVE_REQUESTS     | 100                                          | |
| APACHE_MPM_EVENT_SERVER_LIMIT      | 16                                           | |
| APACHE_MPM_EVENT_MAX_CLIENTS       | 400                                          | |
| APACHE_MPM_EVENT_START_SERVERS     | 3                                            | |
| APACHE_MPM_EVENT_THREADS_PER_CHILD | 25                                           | |
| APACHE_MPM_EVENT_THREAD_LIMIT      | 64                                           | |
| APACHE_REQUEST_READ_TIMEOUT        | header=20-40,MinRate=500 body=20,MinRate=500 | |
| APACHE_SERVER_NAME                 | default                                      | |
| APACHE_SERVER_TOKENS               | Full                                         | |
| APACHE_SERVER_SIGNATURE            | Off                                          | |
| APACHE_TIMEOUT                     | 60                                           | |
| APACHE_USE_CANONICAL_NAME          | Off                                          | |

## Enabled Modules

| Variable | 2.4 | 2.2 |
| -------- | --- | --- |
| mod_access_compat   |  | - |
| mod_alias           |  |   |
| mod_auth_basic      |  |   |
| mod_authn_file      |  |   |
| mod_authn_core      |  | - |
| mod_authz_core      |  | - |
| mod_authz_groupfile |  |   |
| mod_authz_host      |  |   |
| mod_authz_user      |  |   |
| mod_autoindex       |  |   |
| mod_deflate         |  |   |
| mod_dir             |  |   |
| mod_env             |  |   |
| mod_expires         |  |   |
| mod_filter          |  |   |
| mod_headers         |  |   |
| mod_http2           |  | - |
| mod_ldap            |  |   |
| mod_log_config      |  |   |
| mod_log_debug       |  | - |
| mod_mime            |  |   |
| mod_negotiation     |  |   |
| mod_reqtimeout      |  |   |
| mod_rewrite         |  |   |
| mod_proxy_fcgi      |  | - |
| mod_proxy           |  |   |
| mod_proxy_http2     |  | - |
| mod_setenvif        |  |   |
| mod_ssl             |  |   |
| mod_status          |  |   |
| mod_unixd           |  | - |
| mod_version         |  |   |

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

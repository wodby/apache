ServerRoot "/usr/local/apache2"

Listen 80

LoadModule access_compat_module modules/mod_access_compat.so
LoadModule alias_module modules/mod_alias.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule deflate_module modules/mod_deflate.so
LoadModule dir_module modules/mod_dir.so
LoadModule env_module modules/mod_env.so
LoadModule expires_module modules/mod_expires.so
LoadModule filter_module modules/mod_filter.so
LoadModule headers_module modules/mod_headers.so
LoadModule http2_module modules/mod_http2.so
LoadModule ldap_module modules/mod_ldap.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule log_debug_module modules/mod_log_debug.so
LoadModule mime_module modules/mod_mime.so
LoadModule negotiation_module modules/mod_negotiation.so
LoadModule reqtimeout_module modules/mod_reqtimeout.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
LoadModule proxy_http2_module modules/mod_proxy_http2.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule status_module modules/mod_status.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule version_module modules/mod_version.so

<IfModule unixd_module>

User {{ getenv "APACHE_USER" "apache" }}
Group {{ getenv "APACHE_GROUP" "apache" }}

</IfModule>

ServerName localhost

<Directory />
    AllowOverride none
    Require all denied
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog /proc/self/fd/2
LogLevel {{ getenv "APACHE_LOG_LEVEL" "warn" }}

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>

    CustomLog /proc/self/fd/1 common env=!dontlog
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/usr/local/apache2/cgi-bin/"

</IfModule>

<Directory "/usr/local/apache2/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule headers_module>
    RequestHeader unset Proxy early
</IfModule>

<IfModule mime_module>
    TypesConfig conf/mime.types

    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
</IfModule>

Include conf/extra/httpd-mpm.conf

<IfModule proxy_html_module>
Include conf/extra/proxy-html.conf
</IfModule>

<IfModule ssl_module>
SSLRandomSeed startup builtin
SSLRandomSeed connect builtin
</IfModule>

Timeout {{ getenv "APACHE_TIMEOUT" "60" }}
KeepAlive {{ getenv "APACHE_KEEP_ALIVE" "On" }}
MaxKeepAliveRequests {{ getenv "APACHE_MAX_KEEP_ALIVE_REQUESTS" "100" }}
KeepAliveTimeout {{ getenv "APACHE_KEEP_ALIVE_TIMEOUT" "5" }}
UseCanonicalName {{ getenv "APACHE_USE_CANONICAL_NAME" "Off" }}
AccessFileName .htaccess

ServerTokens {{ getenv "APACHE_SERVER_TOKENS" "Full" }}

ServerSignature {{ getenv "APACHE_SERVER_SIGNATURE" "Off" }}
HostnameLookups {{ getenv "APACHE_HOSTNAME_LOOKUPS" "Off" }}

<IfModule reqtimeout_module>
  RequestReadTimeout {{ getenv "APACHE_REQUEST_READ_TIMEOUT" "header=20-40,MinRate=500 body=20,MinRate=500" }}
</IfModule>

<IfModule event.c>
ServerLimit           {{ getenv "APACHE_MPM_EVENT_SERVER_LIMIT" "16" }}
MaxClients            {{ getenv "APACHE_MPM_EVENT_MAX_CLIENTS" "400" }}
StartServers          {{ getenv "APACHE_MPM_EVENT_START_SERVERS" "3" }}
ThreadsPerChild       {{ getenv "APACHE_MPM_EVENT_THREADS_PER_CHILD" "25" }}
ThreadLimit           {{ getenv "APACHE_MPM_EVENT_THREAD_LIMIT" "64" }}
</IfModule>

Include {{ getenv "APACHE_INCLUDE_CONF" "conf/conf.d/*.conf" }}
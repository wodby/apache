<VirtualHost *:80>
    DocumentRoot "{{ getenv "APACHE_DOCUMENT_ROOT" "/var/www/html" }}"
    ServerName {{ getenv "APACHE_SERVER_NAME" "default" }}

    <Directory "{{ getenv "APACHE_DOCUMENT_ROOT" "/var/www/html" }}">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

{{ if getenv "APACHE_HTTP2" }}
    Protocols h2c http/1.1
{{ end }}
    Include conf/healthz.conf
</VirtualHost>

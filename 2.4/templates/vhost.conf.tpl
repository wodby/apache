<VirtualHost *:80>
    DocumentRoot "/usr/local/apache2/htdocs"
    ServerName {{ getenv "APACHE_SERVER_NAME" "default" }}
</VirtualHost>

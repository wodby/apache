{{ if getenv "APACHE_ENABLE_HEALTHZ_LOG" }}{{ else }}
SetEnvIf Request_URI "^/\.healthz$" dontlog
{{ end }}
RedirectMatch 204 .healthz

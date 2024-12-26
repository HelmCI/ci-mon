{{- $s := .Release.Store }}
Secret:
  metadata:
    name: auth-generic-oauth-secret
  stringData:
    client_secret: {{ $s.grafana.oidc }}

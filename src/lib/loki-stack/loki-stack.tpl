{{- $s := .Release.Store }}
{{- $r := $s.registry }}
{{- $dhub := print $r.hostProxy "/" $r.proxy.docker }}

test_pod:
  enabled: false

loki:
  config:
    table_manager:
      retention_deletes_enabled: true
      retention_period: 1w
  persistence:
    enabled: true
  {{- with or $s.host $s.mon.host }}
  nodeSelector: 
    kubernetes.io/hostname: {{ . }}
  {{- end }}

{{- with $r.hostProxy }}
  image:
    repository: {{ $dhub }}/grafana/loki
    tag: &loki 2.8.2
promtail:
  image:
    registry: {{ $dhub }}
    tag: *loki
{{- end }}

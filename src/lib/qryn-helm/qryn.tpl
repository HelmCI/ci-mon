{{- $s := .Release.Store }}
{{- $r    := $s.registry }}

image:
  {{/* tag: "" */}}
  repository: qxip/qryn
  {{- with $r.hostProxy }}
  repository: {{ . }}/{{ $r.proxy.docker }}/qxip/qryn
  {{- end }}

env:
  CLICKHOUSE_SERVER: clickhouse.db
  {{/* CLICKHOUSE_AUTH: "default:pass" */}} # TODO: need patch chart

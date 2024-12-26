# file://./pyroscope.md
{{- $s := .Release.Store }}
{{- $r := $s.registry }}

{{- with $r.hostProxy }}
pyroscope:
  image:
    repository: {{ . }}/{{ $r.proxy.docker }}/grafana/pyroscope
{{- end }}

agent:
  enabled: false

# file://./tempo.md
{{- $s := .Release.Store }}
{{- $r    := $s.registry }}

{{- with $r.hostProxy }}
tempo:
  repository: {{ . }}/{{ $r.proxy.docker }}/grafana/tempo
{{- end }}

persistence:
  enabled: true

{{- with or $s.host  $s.mon.host }}
nodeSelector: 
  kubernetes.io/hostname: {{ . }}
{{- end }}

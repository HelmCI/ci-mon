# file://./jaeger.md
{{- $s := .Release.Store }}
{{- $r := $s.registry }}

{{- with $r.hostProxy }}
global:
  imageRegistry: {{ . }}/{{ $r.proxy.docker }}/grafana/pyroscope
{{- end }}

allInOne:
  enabled: true
  image:
    tag: 1.60.0 # https://github.com/jaegertracing/jaeger/releases

  {{- with or $s.host $s.mon.host }}
  nodeSelector: 
    kubernetes.io/hostname: {{ . }}
  {{- end }}

storage:
  type: badger # memory
  badger:
    ephemeral: false
    persistence:
      useExistingPvcName: jaeger-add

provisionDataStore:
  cassandra: false
agent:
  enabled: false
collector:
  enabled: false
query:
  enabled: false

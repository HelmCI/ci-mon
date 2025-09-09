{{- $s := .Release.Store }}
service:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/path: "/metrics"
    {{- with $s.metrics.port }}
    prometheus.io/port: {{ . | quote }}
    {{- end }}

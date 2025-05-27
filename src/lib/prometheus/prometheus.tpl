# file://./prometheus.md
{{- $s := .Release.Store }}
{{- $r := $s.registry }}

{{- $repo := print $r.hostProxy "/" }}
{{- $k8s  := print $repo $r.proxy.registry_k8s_io }}
{{- $quay := print $repo $r.proxy.quay_io }}
{{/* {{- $quay := print $repo $r.proxy.quay_io "/prometheus" }} */}}

{{- with $r.hostProxy }}
server:
  {{- with or $s.host $s.mon.host }}
  nodeSelector: 
    kubernetes.io/hostname: {{ . }}
  {{- end }}
  image: # quay.io/prometheus/prometheus
    repository: {{ $quay }}/prometheus/prometheus
imagePullSecrets:
  - name: imagepullsecret-patcher
configmapReload:
  prometheus:
    image: # quay.io/prometheus-operator/prometheus-config-reloader
      repository: {{ $quay }}/prometheus-operator/prometheus-config-reloader
kube-state-metrics:
  image:
    registry: {{ $k8s }} # registry.k8s.io
    # tag: v2.15.0 # https://explore.ggcr.dev/?repo=registry.k8s.io/kube-state-metrics/kube-state-metrics
prometheus-node-exporter:
  image:
    registry: {{ $quay }} # quay.io
    # tag: v1.9.1
{{- end }}

prometheus-pushgateway:
  enabled: false
alertmanager:
  enabled: false

{{- with $s.extraScrapeConfigs }}
extraScrapeConfigs: |
{{ toYAML . | indent 2 }}
{{- end }}

{{- define "sip" -}}
- job_name: asterisk
  fallback_scrape_protocol: PrometheusText0.0.4
  static_configs:
    - targets:
      - {{ . }}:8088
{{- end }}
{{- with $s.sip.host }}
extraScrapeConfigs: |
{{ tmpl.Exec "sip" . | indent 2 }}
{{- end }}

# https://artifacthub.io/packages/helm/prometheus-community/prometheus
{{- $s := .Release.Store }}
{{- $r    := $s.registry }}

{{- $repo := print $r.hostProxy "/" }}
{{- $k8s   := print $repo $r.proxy.k8s }}
{{- $quay  := print $repo $r.proxy.quay "/prometheus" }}

{{- with $r.hostProxy }}
server:
  {{- with or $s.host $s.mon.host }}
  nodeSelector: 
    kubernetes.io/hostname: {{ . }}
  {{- end }}
  image:
    repository: {{ $quay }}/prometheus
imagePullSecrets:
  - name: imagepullsecret-patcher
configmapReload:
  prometheus:
    image:
      repository: {{ $quay }}-operator/prometheus-config-reloader
kube-state-metrics:
  image:
    repository: {{ $k8s }}/kube-state-metrics/kube-state-metrics
    tag: v2.13.0  # https://explore.ggcr.dev/?repo=registry.k8s.io/kube-state-metrics/kube-state-metrics
prometheus-node-exporter:
  image:
    repository: {{ $quay }}/node-exporter
    tag: v1.7.0
{{- end }}

prometheus-pushgateway:
  enabled: false
alertmanager:
  enabled: false

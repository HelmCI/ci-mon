# file://./metrics-server.md
{{- $r := .Release.Store.registry }}
{{- with $r.hostProxy }}
image:
  repository: {{ . }}/{{ $r.proxy.k8s }}/metrics-server/metrics-server
imagePullSecrets: 
  - name: imagepullsecret-patcher
{{- end }}

args:
  - --kubelet-insecure-tls

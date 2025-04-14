# file://./metrics-server.md
{{- $r := .Release.Store.registry }}
{{- with $r.hostProxy }}
image:
  repository: {{ . }}/{{ $r.proxy.registry_k8s_io }}/metrics-server/metrics-server
imagePullSecrets: 
  - name: imagepullsecret-patcher
{{- end }}

args:
  - --kubelet-insecure-tls

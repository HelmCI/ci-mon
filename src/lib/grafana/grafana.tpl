# file://./grafana.md
{{- $s := .Release.Store }}
{{- $r := $s.registry }}
{{- $host := or $s.host  $s.mon.host }}
{{- $_     := print $s.__ "/grafana/" }}
{{- $oidc  :=  $s.oidc }}
{{- $_oidc := $s.oidc.grafana }}
{{- $oidc_url := print (or $_oidc.url $oidc.url)  "/realms/" (or $_oidc.realm $oidc.realm) "/protocol/openid-connect" }}
{{- $sub_path := "mon" }}

{{- $init := or (getenv "I") $s.init }}
{{- $f := "file://./../../../../" }}
{{- $path := "/grafana/dashboards/" }}
{{- $files := dict }}
{{- range $s._modules | append "" }}
  {{- $_ := filepath.Join . $s._ $path }}
  {{- if file.Exists $_  }}
    {{- range file.ReadDir $_ }}
      {{- $folder := . }}
      {{- with filepath.Join $_ . }}
      {{- $_ := . }}
      {{- if file.IsDir . }}
        {{- range file.ReadDir . }}
          {{- $name := filepath.Base . | strings.TrimSuffix (filepath.Ext .) }}
          {{- if filepath.Ext .  | eq ".json" }}
            {{- with filepath.Join $_ . }}
              {{- if file.Exists .  }} 
# {{ $f }}{{ . }}
                {{- $files =  readFile . | dict $name | dict $folder | merge $files }}
              {{- end }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{/* podAnnotations: # debug
  {{- range $k, $v := $files }}
  {{ $k }}: {{ $v | keys }}
  {{- end }} */}}

{{- with $r.hostProxy }}
global:
  imageRegistry: {{ . }}/{{ $r.proxy.docker }}
image:
  pullSecrets:
  - name: imagepullsecret-patcher
{{- end }}

persistence:
  enabled: true
  lookupVolumeName: false

{{- with $host }}
nodeSelector: 
  kubernetes.io/hostname: {{ . }}
{{- end }}

testFramework:
  enabled: false

datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server:80
      access: proxy
      isDefault: true
    - name: Loki
      type: loki
      url: http://loki-stack:3100
      access: proxy
    - name: Tempo
      type: tempo
      url: http://tempo:3100
      access: proxy
    {{/* - name: Jaeger
      type: jaeger
      url: http://jaeger-query:16686
      access: proxy */}}
    - name: Pyroscope
      type: grafana-pyroscope-datasource
      url: http://pyroscope:4040
      access: proxy

adminPassword: {{ $s.grafana.password }}

ingress:
  enabled: true
  hosts: []
  path: /({{ $sub_path }}/.*)
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/enable-opentelemetry: "false"

grafana.ini:
  analytics:
    check_for_updates: false
  server:
    root_url: '%(protocol)s://%(domain)s/{{ $sub_path }}'
    serve_from_sub_path: true
    domain: {{ $s.ingress.host0 }}

{{- if $s.grafana.oidc }}
  auth:
    oauth_allow_insecure_email_lookup: true
  auth.generic_oauth:
    enabled: true
    name: Git-Data
    allow_sign_up: true
    scopes: openid profile email roles
    auth_url:  {{ $oidc_url }}/auth
    token_url: {{ $oidc_url }}/token
    api_url:   {{ $oidc_url }}/userinfo
    login_attribute_path:	preferred_username
    role_attribute_strict:	true
    role_attribute_path: contains(roles[*], 'Admin') && 'Admin' || contains(roles[*], 'Editor') && 'Editor'
    client_id: grafana
    client_secret: $__file{/etc/secrets/auth_generic_oauth/client_secret}
{{- end}}

{{- with $s.smtp }}
  smtp:	
    enabled: true
    host:	{{ .host }}
    from_address:	{{ .from_address }}
    from_name:	Grafana
smtp:
  existingSecret: smtp
{{- end}}

{{- with $s.grafana.oidc }}
extraSecretMounts:
- name: auth-generic-oauth-secret-mount
  secretName: auth-generic-oauth-secret
  defaultMode: 0440
  mountPath: /etc/secrets/auth_generic_oauth
  readOnly: true
{{- end}}

dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    - name: default
      options:
        path: /var/lib/grafana/dashboards/default
    - name: node-exporter
      folder: Node Exporter
      options:
        path: /var/lib/grafana/dashboards/node-exporter
    - name: infra
      folder: Infra
      options:
        path: /var/lib/grafana/dashboards/infra
    - name: kubernetes
      folder: Kubernetes
      options:
        path: /var/lib/grafana/dashboards/kubernetes
dashboards:
  {{- if not $init }}
  {{- range $k, $v := $files }}
  {{ $k }}:
    {{- range $k, $v := $v }}
    {{ $k }}:
      json: |
{{ $v | indent 8 }}
    {{- end }}
  {{- end }}
  {{- else }}
  infra:
    prometheus:
      gnetId: 3662
      datasource: Prometheus
    CoreDNS:
      gnetId: 14981
      datasource: Prometheus
  node-exporter:
    node-exporter-11074:
      gnetId: 11074
      datasource: Prometheus
    node-exporter-15172:
      gnetId: 15172
      datasource: Prometheus
    node-exporter-full:
      gnetId: 12486 # 1860
      datasource: Prometheus
  kubernetes:
    k8s-views-global:
      url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-global.json
    k8s-views-namespaces:
      url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-namespaces.json
    k8s-views-nodes:
      url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-nodes.json
    k8s-views-pods:
      url: https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-pods.json
  {{- end }}

# file://./sentry.md
{{- $s := .Release.Store }}
{{- $init := or (getenv "I") $s.init }}

{{- $r    := $s.registry }}
{{- $dhub := print $r.hostProxy "/" $r.proxy.docker }}
{{- $getsentry := print $dhub "/getsentry" }}

.registry:
  dhub: &dhub {{ $dhub }}

.affinity: &affinity
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - {{ $s.host }}

ingress:
  enabled: true
  hostname: {{ or $s.hostname "sentry" }}

nginx:
{{- with $r.hostProxy }}
  image:
    registry: *dhub
{{- end }}  
  service:
    type: NodePort
    nodePorts:
      http: {{ $s.port | quote }}
  clusterDomain: {{ $s.cluster.name }}

system:
  url: {{ or $s.url "http://sentry" }}

user:
  email: admin@sentry.local
  password: {{ $s.grafana.password }}
{{- if not $init }}
  create: false
asHook: false
hooks:
  enabled: false
  {{- with $r.hostProxy }}
  dbCheck:
    image:
      repository: {{ $dhub }}/subfuzion/netcat
  {{- end }}
{{- end }}

sentry:
  worker:
    replicas: 1
  cleanup:
    days: 14 # 90
{{- if not $init }}
  existingSecret: sentry-sentry-secret
{{- end }}
{{- with $s.host }}
  web:             
    affinity: *affinity
{{- end }}  

clickhouse:
  clickhouse:
  {{- with $r.hostProxy }}
    image: {{ $dhub }}/yandex/clickhouse-server
  {{- end }}  
    replicas: 1
{{- with $s.host }}              
  affinity: *affinity
{{- end }}  
  clusterDomain: {{ $s.cluster.name }}

kafka:
{{- with $r.hostProxy }}
  image:
    registry: *dhub
{{- end }}
  replicaCount: &replicaCount 1
  defaultReplicationFactor: *replicaCount
  offsetsTopicReplicationFactor: *replicaCount
  transactionStateLogReplicationFactor: *replicaCount
  logRetentionHours: 24 # 168
  clusterDomain: {{ $s.cluster.name }}
{{- if not $init }}
  provisioning:
    enabled: false
    replicationFactor: *replicaCount
{{- end }}
{{- with $s.host }}              
  affinity: *affinity
{{- end }} 
  zookeeper:
  {{- with $r.hostProxy }}
    image:
      registry: *dhub
  {{- end }}  
    autopurge: &autopurge
      purgeInterval: 24
  {{- with $s.host }}              
    affinity: *affinity
  {{- end }}  

zookeeper:
{{- with $r.hostProxy }}
  image:
    registry: *dhub
{{- end }}  
  replicaCount: 1
  autopurge: *autopurge

{{- with $s.host }}              
  affinity: *affinity
{{- end }}  
  clusterDomain: {{ $s.cluster.name }}

rabbitmq:
{{- with $r.hostProxy }}
  image:
    registry: *dhub
{{- end }}  
  replicaCount: 1
  clusterDomain: {{ $s.cluster.name }}
  ulimitNofiles: ""
{{- with $s.host }}              
  affinity: *affinity
{{- end }}  

redis:
{{- with $r.hostProxy }}
  image:
    registry: *dhub
{{- end }}  
  architecture: standalone
  master:
{{- with $s.host }}              
    affinity: *affinity
{{- end }}  
  clusterDomain: {{ $s.cluster.name }}

postgresql:
{{- with $r.hostProxy }}
  image:
    registry: *dhub
{{- end }}  
  auth:
    existingSecret: "db"
    secretKeys:
      adminPasswordKey: postgres
      replicationPasswordKey: postgres
{{- with $s.host }}              
  primary:
    affinity: *affinity
{{- end }}  

{{- with $r.hostProxy }}
images:
  relay:
    repository: {{ $getsentry }}/relay
  sentry:
    repository: {{ $getsentry }}/sentry
  snuba:
    repository: {{ $getsentry }}/snuba
  symbolicator:
    repository: {{ $getsentry }}/symbolicator
  vroom:
    repository: {{ $getsentry }}/vroom
{{- end }}  

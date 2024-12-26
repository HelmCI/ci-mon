# https://grafana.com/docs/loki/latest/installation/helm/install-monolithic/
loki:
  commonConfig:
    replication_factor: 1
  storage:
    type: 'filesystem'
singleBinary:
  replicas: 1
  persistence:
    size: 1Gi

test:
  enabled: false
{{/* gateway: */}}
  {{/* enabled: false */}}
monitoring:
  dashboards:
    enabled: false
  rules:
    enabled: false
  lokiCanary:
    enabled: false
  serviceMonitor:
    enabled: false
  selfMonitoring:
    enabled: false
    grafanaAgent:
      installOperator: false

write:
  replicas: 0
read:
  replicas: 0
backend:
  replicas: 0

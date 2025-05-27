# Prometheus

- [.. HOME](../../../README.md)
- [chart](../../../charts/prometheus/README.md)
- [values template](prometheus.tpl)
- https://artifacthub.io/packages/helm/prometheus-community/prometheus

## debug

- 'http://localhost:55381/api/v1/query?query=node_filesystem_avail_bytes'
- 'http://localhost:55381/api/v1/series?match[]={app_kubernetes_io_instance="prometheus",app_kubernetes_io_instance="node_exporter"}'
- 'http://localhost:55381/api/v1/status/tsdb?limit=5'
- 'http://localhost:55381/api/v1/status/tsdb'
- 'http://localhost:55381/api/v1/label/app_kubernetes_io_instance/values'
- 'http://localhost:55381/api/v1/label/service/values'

## SIP example

```yaml
  mon:
    chart:
      prometheus:
        prometheus:
          store: 
            extraScrapeConfigs:
              - job_name: asterisk
                fallback_scrape_protocol: PrometheusText0.0.4
                static_configs:
                  - targets:
                    - 10.10.10.1:8088
```

# Continuous Integration module - Monitoring (observability)

- [*base on core sub module with helmwave engine](ci/README.md)

## quick start 

```sh
brew install make git
git submodule update --init

make test_quick_start_mon # 15.3s

# OR:
echo y | make test_cluster_delete # 815ms 
echo y | make test_cluster_create # 13.4s
make test_up_system       # 12.5s
make test_metrics_server  # 38.6s
make test_up_prometheus   # 1m
make test_up_tempo        # 20.4s
make test_up_loki         # 1.5m
make test_up_pyroscope    # 14.5s
make test_up_jaeger       # 18.5s
make test_up_grafana      # 37.6s
```

## docs

- [metrics-server](src/lib/metrics-server/metrics-server.md)
- [tempo](src/lib/tempo/tempo.md)
- [jaeger](src/lib/jaeger/jaeger.md)
- [pyroscope](src/lib/pyroscope/pyroscope.md)
- [sentry](src/lib/sentry/sentry.md)

## values template

- [prometheus](src/lib/prometheus/prometheus.tpl)
- [grafana](src/lib/grafana/grafana.tpl)
- [grafana-agent](src/lib/grafana-agent/grafana-agent.tpl)
- [loki-stack](src/lib/loki-stack/loki-stack.tpl)
- [loki](src/lib/loki/loki.tpl)

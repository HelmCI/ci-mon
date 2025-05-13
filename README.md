# HelmwaveCI module - Monitoring (observability)

Base on [core](https://github.com/HelmCI/ci) ["sub"](ci/README.md) module with [helmwave](https://github.com/helmwave/helmwave) [engine](https://github.com/HelmCI/ci/blob/main/helmwave/helmwave.tpl). And use dependencies:
- module [**ci-infra**](https://github.com/HelmCI/ci-infra) - ["base Infrastructure"](ci-infra/README.md)

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
make test_up_homer
make test_up_homer7
```

## docs

- [metrics-server](src/lib/metrics-server/metrics-server.md)
- [tempo](src/lib/tempo/tempo.md)
- [jaeger](src/lib/jaeger/jaeger.md)
- [pyroscope](src/lib/pyroscope/pyroscope.md)
- [sentry](src/lib/sentry/sentry.md)
- [homer7](src/dc/homer7/homer7.md)
- [homer10](src/dc/homer/README.md) -> [lib](src/lib/mon-homer.md)

## values template

- [prometheus](src/lib/prometheus/prometheus.tpl)
- [grafana](src/lib/grafana/grafana.tpl)
- [grafana-agent](src/lib/grafana-agent/grafana-agent.tpl)
- [loki-stack](src/lib/loki-stack/loki-stack.tpl)
- [loki](src/lib/loki/loki.tpl)

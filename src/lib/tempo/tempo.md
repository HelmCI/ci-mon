# tempo

- [.. HOME](../../../README.md)
- [chart](../../../charts/tempo/README.md)
- [values template](tempo.tpl)
- https://grafana.com/docs/tempo/latest/setup/set-up-test-app/
- https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/cmd/telemetrygen

## test

```sh
go install github.com/open-telemetry/opentelemetry-collector-contrib/cmd/telemetrygen@latest

kubectl port-forward -n mon services/tempo            4317
kubectl port-forward -n mon services/jaeger-collector 4317
kubectl port-forward -n mon services/grafana-agent    4317
telemetrygen traces --otlp-insecure --rate 20 --duration 5s --otlp-endpoint localhost:4317
```

## nginx

- https://github.com/kubernetes/ingress-nginx/pull/9062
- https://kubernetes.github.io/ingress-nginx/user-guide/third-party-addons/opentelemetry/

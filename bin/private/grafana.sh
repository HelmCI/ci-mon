#!/usr/bin/env sh
set -euf
mkdir -p src/_/grafana/dashboards/default
mkdir -p src/_/grafana/dashboards/node-exporter
mkdir -p src/_/grafana/dashboards/infra
mkdir -p src/_/grafana/dashboards/kubernetes

curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://grafana.com/api/dashboards/14981/revisions/1/download" \
  | sed '/-- .* --/! s/"datasource":.*,/"datasource": "Prometheus",/g' \
> "src/_/grafana/dashboards/infra/CoreDNS.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://grafana.com/api/dashboards/3662/revisions/1/download" \
  | sed '/-- .* --/! s/"datasource":.*,/"datasource": "Prometheus",/g' \
> "src/_/grafana/dashboards/infra/prometheus.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-global.json" \
> "src/_/grafana/dashboards/kubernetes/k8s-views-global.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-namespaces.json" \
> "src/_/grafana/dashboards/kubernetes/k8s-views-namespaces.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-nodes.json" \
> "src/_/grafana/dashboards/kubernetes/k8s-views-nodes.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://raw.githubusercontent.com/dotdc/grafana-dashboards-kubernetes/master/dashboards/k8s-views-pods.json" \
> "src/_/grafana/dashboards/kubernetes/k8s-views-pods.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://grafana.com/api/dashboards/11074/revisions/1/download" \
  | sed '/-- .* --/! s/"datasource":.*,/"datasource": "Prometheus",/g' \
> "src/_/grafana/dashboards/node-exporter/node-exporter-11074.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://grafana.com/api/dashboards/15172/revisions/1/download" \
  | sed '/-- .* --/! s/"datasource":.*,/"datasource": "Prometheus",/g' \
> "src/_/grafana/dashboards/node-exporter/node-exporter-15172.json"
  
curl -skf \
--connect-timeout 60 \
--max-time 60 \
-H "Accept: application/json" \
-H "Content-Type: application/json;charset=UTF-8" \
  "https://grafana.com/api/dashboards/12486/revisions/1/download" \
  | sed '/-- .* --/! s/"datasource":.*,/"datasource": "Prometheus",/g' \
> "src/_/grafana/dashboards/node-exporter/node-exporter-full.json"


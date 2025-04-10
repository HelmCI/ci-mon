test_cluster = local-mon

test_quick_start_mon: test_cluster_delete test_cluster_create test_up_system \
	test_metrics_server \
	test_up_prometheus test_up_tempo test_up_loki test_up_pyroscope \
	test_up_jaeger test_up_grafana

test_metrics_server: test_up_metrics_server test_metrics_server_top

test_up_metrics_server:
	helmwave up -t metrics-server
test_up_prometheus:
	helmwave up -t prometheus
test_up_tempo:
	helmwave up -t tempo
test_up_loki:
	helmwave up -t loki-stack
test_up_pyroscope:
	helmwave up -t pyroscope
test_up_jaeger:
	helmwave up -t jaeger-add,jaeger
test_up_grafana:
	helmwave up -t sec-mon,grafana

test_metrics_server_top:
	kubectl top node
	kubectl top pod -A

test_up_homer: homer_up_dc
	helmwave up -t homer,homer_test

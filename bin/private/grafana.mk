GRAFANA_SH = bin/private/grafana.sh

grafana_make_sh:
	I=1 K=k3d-local-mon HELMWAVE_DEPENDENCIES=false HELMWAVE_TAGS=mon@grafana make --no-print-directory helmwave_dump_offline
	yq -r '.data."download_dashboards.sh" | select(.)' tmp/.k3d-local-mon/manifest/grafana@mon@k3d-local-mon.yml \
		| sed 's|/var/lib|src/_|' > $(GRAFANA_SH)
	chmod +x $(GRAFANA_SH)

grafana_update:
	$(GRAFANA_SH)

grafana_clean:
	rm -rf src/_/grafana/dashboards

grafana: \
	grafana_make_sh \
	grafana_update

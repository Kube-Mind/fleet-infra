# MONITORING STACK
.PHONY: grafana-password grafana-proxy grafana-shell
GRAFANA_NAMESPACE=kube-prometheus-stack
GRAFANA_PASSWORD=$$(kubectl -n $(GRAFANA_NAMESPACE) get secret $(GRAFANA_NAMESPACE)-grafana -o=jsonpath='{.data.admin-password}' | base64 -d)
grafana-password:
	@echo $(GRAFANA_PASSWORD)
grafana-shell:
	kubectl -n $(GRAFANA_NAMESPACE) exec -it deploy/$(GRAFANA_NAMESPACE)-grafana -- /bin/sh
grafana-proxy:
	kubectl -n $(GRAFANA_NAMESPACE) port-forward svc/$(GRAFANA_NAMESPACE)-grafana 8080:80
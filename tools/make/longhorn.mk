LONGHORN_NAMESPACE=longhorn
.PHONY: longhorn-proxy
longhorn-proxy:
	kubectl -n $(LONGHORN_NAMESPACE) port-forward svc/longhorn-frontend 8081:80
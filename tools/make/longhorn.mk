LONGHORN_NAMESPACE=longhorn

.PHONY: longhorn-setup longhorn-teardown longhorn-proxy longhorn-password longhorn-login longhorn-wait
LONGHORN_NAMESPACE=longhorn
LONGHORN_PATH=./src/platform/storage/longhorn
LONGHORN_PASSWORD=$$(kubectl -n $(LONGHORN_NAMESPACE) get secret longhorn-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
longhorn-setup:
	$(call kustomize_apply,$(LONGHORN_PATH))

longhorn-teardown:
	$(call kustomize_delete,$(LONGHORN_PATH))

longhorn-proxy:
	kubectl -n $(LONGHORN_NAMESPACE) port-forward svc/longhorn-frontend 8081:80
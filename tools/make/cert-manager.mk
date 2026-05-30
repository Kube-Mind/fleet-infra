.PHONY: cert-manager-setup cert-manager-proxy cert-manager-password cert-manager-login cert-manager-clean cert-manager-wait
CERT_MANAGER_NAMESPACE=cert-manager
CERT_MANAGER_PATH=./src/platform/core/cert-manager
CERT_MANAGER_VALUES=$(CERT_MANAGER_PATH)/values.yaml
CERT_MANAGER_PASSWORD=$$(kubectl -n $(CERT_MANAGER_NAMESPACE) get secret cert-manager-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
cert-manager-setup:
	$(call kustomize_apply,$(CERT_MANAGER_PATH))

cert-manager-clean:
	$(call kustomize_delete,$(CERT_MANAGER_PATH))

cert-manager-wait:
	kubectl -n $(CERT_MANAGER_NAMESPACE) wait -l k8s-app=cilium --for=condition=ready pod --timeout=360s

cert-manager-proxy: cert-manager-password
	kubectl -n $(CERT_MANAGER_NAMESPACE) port-forward svc/hubble-relay 4245:80

cert-manager-password:
	@echo "CERT_MANAGER_PASSWORD: $(CERT_MANAGER_PASSWORD)"

cert-manager-login: cert-manager-password
	@cilium login 127.0.0.1:8080 --insecure --username="admin" --password="$(ARGO_PASSWORD)"

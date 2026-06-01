.PHONY: cert-manager-setup cert-manager-wait cert-manager-teardown
CERT_MANAGER_NAMESPACE=cert-manager
CERT_MANAGER_PATH=./src/platform/core/cert-manager
CERT_MANAGER_VALUES=$(CERT_MANAGER_PATH)/values.yaml
CERT_MANAGER_PASSWORD=$$(kubectl -n $(CERT_MANAGER_NAMESPACE) get secret cert-manager-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
cert-manager-setup:
	$(call kustomize_apply,$(CERT_MANAGER_PATH))

cert-manager-wait:
	$(call k8s_wait_pods_ready,$(CERT_MANAGER_NAMESPACE),app.kubernetes.io/name=cert-manager)

cert-manager-teardown:
	$(call kustomize_delete,$(CERT_MANAGER_PATH))


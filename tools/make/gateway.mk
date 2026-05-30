.PHONY: gateway-crd-setup gateway-crd-clean
GATEWAY_CRD_NAMESPACE=gateway-crd
GATEWAY_CRD_PATH=./src/platform/network/gateway-crd
GATEWAY_CRD_VALUES=$(GATEWAY_CRD_PATH)/values.yaml
GATEWAY_CRD_PASSWORD=$$(kubectl -n $(GATEWAY_CRD_NAMESPACE) get secret gateway-crd-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
gateway-crd-setup:
	$(call kustomize_apply,$(GATEWAY_CRD_PATH))

gateway-crd-clean:
	$(call kustomize_delete,$(GATEWAY_CRD_PATH))


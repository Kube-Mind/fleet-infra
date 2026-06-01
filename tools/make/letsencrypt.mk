
.PHONY: letsencrypt-setup letsencrypt-get-resources letsencrypt-teardown
LETSENCRYPT_NAMESPACE=letsencrypt
LETSENCRYPT_PATH=./src/platform/network/letsencrypt
LETSENCRYPT_VALUES=$(LETSENCRYPT_PATH)/values.yaml
letsencrypt-setup:
	$(call kustomize_apply,$(LETSENCRYPT_PATH))

letsencrypt-get-resources:
	@echo "Getting letsencrypt resources..."
	$(call kustomize_get,$(LETSENCRYPT_PATH))

letsencrypt-teardown:
	$(call kustomize_delete,$(LETSENCRYPT_PATH))
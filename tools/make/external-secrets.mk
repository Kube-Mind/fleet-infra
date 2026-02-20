.PHONY: external-secrets-setup external-secrets-teardown external-secrets-proxy external-secrets-password external-secrets-login external-secrets-wait
EXTERNAL_SECRETS_NAMESPACE=external-secrets
EXTERNAL_SECRETS_PATH=src/platform/core/external-secrets
external-secrets-setup:
	$(call kustomize_apply,$(EXTERNAL_SECRETS_PATH))

external-secrets-teardown:
	$(call kustomize_delete,$(EXTERNAL_SECRETS_PATH))
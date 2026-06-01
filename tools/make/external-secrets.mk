.PHONY: external-secrets-setup external-secrets-teardown external-secrets-wait
EXTERNAL_SECRETS_NAMESPACE=external-secrets
EXTERNAL_SECRETS_PATH=src/platform/security/external-secrets
external-secrets-setup:
	$(call kustomize_server_side_apply,$(EXTERNAL_SECRETS_PATH))

external-secrets-teardown:
	$(call kustomize_delete,$(EXTERNAL_SECRETS_PATH))

external-secrets-wait:
	$(call k8s_wait_pods_ready,$(EXTERNAL_SECRETS_NAMESPACE),app.kubernetes.io/name=external-secrets)
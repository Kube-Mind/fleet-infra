.PHONY: secrets-integrator-setup secrets-integrator-teardown secrets-integrator-proxy secrets-integrator-password secrets-integrator-login secrets-integrator-wait
SECRETS_INTEGRATOR_NAMESPACE=secrets-integrator
SECRETS_INTEGRATOR_PATH=src/platform/security/secrets-integrator
secrets-integrator-setup:
	$(call kustomize_server_side_apply,$(SECRETS_INTEGRATOR_PATH))

secrets-integrator-teardown:
	$(call kustomize_delete,$(SECRETS_INTEGRATOR_PATH))

secrets-integrator-get-resources:
	@echo "Getting secrets-integrator resources..."
	$(call kustomize_get,$(SECRETS_INTEGRATOR_PATH))
	@echo "Getting secrets-integrator secrets"
	kubectl -n $(SECRETS_INTEGRATOR_NAMESPACE) get secrets


secrets-integrator-create-token:
	kubectl -n $(SECRETS_INTEGRATOR_NAMESPACE) create job \
	--from=cronjob.batch/token-generator manual-trigger-$(shell date +%s)
.PHONY: authentik-setup authentik-teardown authentik-proxy authentik-password authentik-login authentik-wait
AUTHENTIK_NAMESPACE=argo-cd
AUTHENTIK_PATH=src/platform/security/authentik
AUTHENTIK_PASSWORD=$$(kubectl -n $(AUTHENTIK_NAMESPACE) get secret authentik-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
authentik-setup:
	$(call kustomize_apply,$(AUTHENTIK_PATH))

authentik-teardown:
	$(call kustomize_delete,$(AUTHENTIK_PATH))
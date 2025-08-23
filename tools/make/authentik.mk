.PHONY: authentik-setup authentik-teardown authentik-proxy authentik-password authentik-login authentik-wait
AUTHENTIK_NAMESPACE=authentik
AUTHENTIK_PATH=src/platform/security/authentik
AUTHENTIK_PASSWORD=$$(kubectl -n $(AUTHENTIK_NAMESPACE) get secret authentik-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
authentik-setup:
	$(call kustomize_apply,$(AUTHENTIK_PATH))

authentik-teardown:
	$(call kustomize_delete,$(AUTHENTIK_PATH))

authentik-proxy:
	kubectl -n $(AUTHENTIK_NAMESPACE) port-forward svc/authentik-server 8080:80
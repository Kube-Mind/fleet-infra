.PHONY: traefik-setup traefik-clean traefik-wait traefik-proxy traefik-password traefik-login traefik-bootstrap
TRAEFIK_NAMESPACE=traefik
TRAEFIK_PATH=./src/platform/network/traefik
TRAEFIK_VALUES=$(TRAEFIK_PATH)/traefik.values.yaml
TRAEFIK_PASSWORD=$$(kubectl -n $(TRAEFIK_NAMESPACE) get secret traefik-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
traefik-setup:
	$(call kustomize_apply,$(TRAEFIK_PATH))

traefik-teardown:
	$(call kustomize_delete,$(TRAEFIK_PATH))
.PHONY: cilium-setup cilium-proxy cilium-password cilium-login cilium-clean cilium-wait
CILIUM_NAMESPACE=cilium
CILIUM_PATH=./src/platform/network/cilium
CILIUM_VALUES=$(CILIUM_PATH)/values.yaml
CILIUM_PASSWORD=$$(kubectl -n $(CILIUM_NAMESPACE) get secret cilium-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
cilium-setup:
	$(call kustomize_apply,$(CILIUM_PATH))

cilium-clean:
	$(call kustomize_delete,$(CILIUM_PATH))

cilium-wait:
	kubectl -n $(CILIUM_NAMESPACE) wait -l k8s-app=cilium --for=condition=ready pod --timeout=360s

cilium-proxy: cilium-password
	kubectl -n $(CILIUM_NAMESPACE) port-forward svc/hubble-relay 4245:80

cilium-password:
	@echo "CILIUM_PASSWORD: $(CILIUM_PASSWORD)"

cilium-login: cilium-password
	@cilium login 127.0.0.1:8080 --insecure --username="admin" --password="$(ARGO_PASSWORD)"

cilium-bootstrap: cilium-login
	cilium app create main \
		--dest-namespace $(CILIUM_NAMESPACE) \
		--dest-server https://kubernetes.default.svc \
		--repo https://gitlab.com/kube-mind/fleet-infra.git \
		--path src/main  
	cilium app sync main
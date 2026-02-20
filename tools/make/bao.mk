.PHONY: bao-shell bao-unseal bao-login

OPENBAO_NAMESPACE=openbao
OPENBAO_PATH=src/platform/security/openbao
bao-setup:
	$(call kustomize_apply,$(OPENBAO_PATH))

bao-teardown:
	$(call kustomize_delete,$(OPENBAO_PATH))

bao-init:
	kubectl -n $(OPENBAO_NAMESPACE) exec -ti pod/openbao-0 -- sh -c 'bao operator init -format yaml'

bao-shell:
	kubectl -n $(OPENBAO_NAMESPACE) exec -ti pod/openbao-0 -- sh

bao-unseal:
	kubectl -n $(OPENBAO_NAMESPACE) exec -ti pod/openbao-0 -- sh -c 'bao operator unseal'

bao-login:
	kubectl -n $(OPENBAO_NAMESPACE) exec -ti pod/openbao-0 -- sh -c 'bao login'

.PHONY: get-k8s-service-ip bao-k8s-write-config bao-k8s-init bao-k8s-read-config
KUBERNETES_PORT_443_TCP_ADDR := $$(kubectl get svc kubernetes -o jsonpath='{.spec.clusterIP}')
get-k8s-service-ip:
	@echo "KUBERNETES_PORT_443_TCP_ADDR=$(KUBERNETES_PORT_443_TCP_ADDR)"

bao-k8s-write-config:
	kubectl -n $(OPENBAO_NAMESPACE) exec -ti pod/openbao-0 -- sh -c 'bao write auth/kubernetes/config \
    kubernetes_host="https://$$KUBERNETES_PORT_443_TCP_ADDR:443" \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    issuer="https://kubernetes.default.svc.cluster.local"'

bao-k8s-read-config:
	kubectl -n $(OPENBAO_NAMESPACE) exec -ti pod/openbao-0 -- sh -c 'bao read auth/kubernetes/config'

bao-k8s-init: get-k8s-service-ip bao-login bao-k8s-write-config bao-k8s-read-config
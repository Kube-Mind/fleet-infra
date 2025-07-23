.PHONY: argocd-setup argocd-teardown argocd-proxy argocd-password argocd-login argocd-wait
ARGOCD_NAMESPACE=argo-cd
ARGOCD_VALUES=./src/projects/configurations/argo-cd.yaml
ARGOCD_PASSWORD=$$(kubectl -n $(ARGOCD_NAMESPACE) get secret argocd-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
argocd-setup:
	$(call kustomize_apply,src/platform/core/argo-cd)

argocd-teardown:
	$(call kustomize_delete,src/platform/core/argo-cd)

argocd-wait:
	kubectl -n $(ARGOCD_NAMESPACE) wait -l app.kubernetes.io/name=argocd-server --for=condition=ready pod --timeout=360s

argocd-proxy: argocd-password
	kubectl -n $(ARGOCD_NAMESPACE) port-forward svc/argo-cd-server 8080:80

argocd-password:
	@echo "ARGOCD_PASSWORD: $(ARGOCD_PASSWORD)"

argocd-login: argocd-password
	@argocd login 127.0.0.1:8080 --insecure --username="admin" --password="$(ARGO_PASSWORD)"

argocd-bootstrap: argocd-login
	argocd app create main \
		--dest-namespace $(ARGOCD_NAMESPACE) \
		--dest-server https://kubernetes.default.svc \
		--repo https://gitlab.com/kube-mind/fleet-infra.git \
		--path src/main  
	argocd app sync main
.PHONY: cluster-setup cluster-teardown
CLUSTER=ha-cluster

cluster-setup:
	k3d cluster create -c k3d/$(CLUSTER).yaml
cluster-start:
	k3d cluster start $(CLUSTER)
cluster-stop:
	k3d cluster stop $(CLUSTER)
cluster-teardown:
	k3d cluster delete -c $(CLUSTER).yaml

.PHONY: argocd-install argocd-proxy argocd-password argocd-login argocd-clean argocd-wait
NAMESPACE=argo-cd
ARGOCD_VALUES=./src/projects/configurations/argo-cd.yaml
ARGOCD_PASSWORD=$$(kubectl -n $(NAMESPACE) get secret argocd-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
argocd-install:
	helm -n $(NAMESPACE) upgrade --install --create-namespace argo-cd argo/argo-cd --reuse-values --values=$(ARGOCD_VALUES)
	$(MAKE) argocd-wait

argocd-wait:
	kubectl -n $(NAMESPACE) wait -l app.kubernetes.io/name=argo-cd-server --for=condition=ready pod --timeout=360s

argocd-proxy:
	kubectl -n $(NAMESPACE) port-forward svc/argo-cd-server 8080:80

argocd-password:
	@echo "ARGOCD_PASSWORD: $(ARGOCD_PASSWORD)"

argocd-login: argocd-password
	@argocd login 127.0.0.1:8080 --insecure --username="admin" --password="$(ARGO_PASSWORD)"

argocd-bootstrap: argocd-login
	argocd app create main \
		--dest-namespace $(NAMESPACE) \
		--dest-server https://kubernetes.default.svc \
		--repo https://gitlab.com/kube-mind/fleet-infra.git \
		--path src/main  
	argocd app sync main
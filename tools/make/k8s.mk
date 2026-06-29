.PHONY: k8s-clean-stale-rs k8s-clean-stale-volumes k8s-clean-orphans
k8s-clean-stale-rs:
	kubectl get rs -A -o json \
		| jq -r '.items[] \
			| select( \
				(.spec.replicas // 0) == 0 and \
				(.status.replicas // 0) == 0 and \
				(.status.readyReplicas // 0) == 0 and \
				(.status.availableReplicas // 0) == 0 \
			) | "kubectl delete rs -n \(.metadata.namespace) \(.metadata.name)" \
			' \
		| sh

k8s-clean-stale-volumes:
	kubectl -n longhorn get volumes -o json \
		| jq -r '.items[] \
		| select(.status.state=="detached" and .status.robustness=="unknown") \
		| .metadata.name' \
		| xargs -r kubectl -n longhorn delete volume

k8s-clean-orphans:
	kubectl get orphans -A -o json \
		| jq -r '.items[] \
		| .metadata.name' \
		| xargs -r kubectl -n longhorn delete orphan

.PHONY: k8s-clean-stale-pods
k8s-clean-stale-pods:
	@echo "Deleting pods with status: ContainerStatusUnknown..."
	kubectl get pods -A -o json \
		| jq -r '.items[] \
			| select( \
				.status.containerStatuses[]?.state.terminated.reason == "ContainerStatusUnknown" \
			) | "kubectl delete pod -n \(.metadata.namespace) \(.metadata.name) --grace-period=0 --force" \
			' \
		| sh
	@echo "Deleting pods with status: ImagePullBackOff..."
	kubectl get pods -A -o json \
		| jq -r '.items[] \
			| select( \
				.status.containerStatuses[]?.state.terminated.reason == "ImagePullBackOff" \
			) | "kubectl delete pod -n \(.metadata.namespace) \(.metadata.name) --grace-period=0 --force" \
			' \
		| sh
	@echo "Deleting pods with status: Error..."
	kubectl get pods -A -o json \
		| jq -r '.items[] \
			| select( \
				.status.containerStatuses[]?.state.terminated.reason == "Error" \
			) | "kubectl delete pod -n \(.metadata.namespace) \(.metadata.name) --grace-period=0 --force" \
			' \
		| sh
	@echo "Deleting pods with status: Unknown..."
	kubectl get pods -A -o json \
		| jq -r '.items[] \
			| select( \
				.status.containerStatuses[]?.state.terminated.reason == "Unknown" \
			) | "kubectl delete pod -n \(.metadata.namespace) \(.metadata.name) --grace-period=0 --force" \
			' \
		| sh
	@echo "Deleting pods with status: Unknown..."
	kubectl get pods -A -o json \
		| jq -r '.items[] \
			| select( \
				.status.containerStatuses[]?.state.terminated.reason == "Unknown" \
			) | "kubectl delete pod -n \(.metadata.namespace) \(.metadata.name) --grace-period=0 --force" \
			' \
		| sh
	@echo "Deleting pods with status: Completed..."
	kubectl get pods -A -o json \
		| jq -r '.items[] \
			| select( \
				.status.containerStatuses[]?.state.terminated.reason == "Completed" \
			) | "kubectl delete pod -n \(.metadata.namespace) \(.metadata.name) --grace-period=0 --force" \
			' \
		| sh
	@echo "Cleanup complete."

.PHONY: k8s-watch-nodes k8s-dns-test
k8s-watch-nodes:
	watch kubectl get nodes

k8s-dns-test:
	kubectl run dns-test --rm -i -t --image=busybox:1.35 --restart=Never -- sh

.PHONY: k8s-test-setup k8s-test-teardown
k8s-test-setup:
_TEST_PATH = 

k8s-test-setup:
	$(call kustomize_apply,$(_TEST_PATH))
k8s-test-teardown:
	$(call kustomize_delete,$(_TEST_PATH))

define kustomize_apply
	@echo "Applying kustomization in $(1)"
	kustomize build --enable-helm $(1) | kubectl apply -f -
endef

define kustomize_server_side_apply
	@echo "Applying server-side kustomization in $(1)"
	kustomize build --enable-helm $(1) | kubectl apply --server-side -f -
endef

define kustomize_get
	@echo "Applying server-side kustomization in $(1)"
	kustomize build --enable-helm $(1) | kubectl get -f -
endef

define kustomize_delete
	@echo "Deleting kustomization in $(1)"
	kustomize build --enable-helm $(1) | kubectl delete -f -
endef

define k8s_wait_pods_ready
	@echo "Waiting for pods with the label $(2) to be ready in namespace $(1)..."
	kubectl -n $(1) wait --for=condition=ready pod -l $(2) --timeout=360s
	@echo ""
endef
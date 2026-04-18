.PHONY: test-setup test-teardown
test-setup:
_TEST_PATH = 

test-setup:
	$(call kustomize_apply,$(_TEST_PATH))
test-teardown:
	$(call kustomize_delete,$(_TEST_PATH))

define kustomize_apply
	echo "Applying kustomization in $(1)"
	# --server-side is required by the following applications
	# - argo-cd
	kustomize build --enable-helm $(1) | kubectl apply --server-side -f -
endef

define kustomize_delete
	kustomize build --enable-helm $(1) | kubectl delete -f -
endef
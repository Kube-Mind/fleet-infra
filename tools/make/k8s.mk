.PHONY: test-setup test-teardown
test-setup:
_TEST_PATH = 

test-setup:
	$(call kustomize_apply,$(_TEST_PATH))
test-teardown:
	$(call kustomize_delete,$(_TEST_PATH))

define kustomize_apply
	kustomize build --enable-helm $(1) | kubectl apply -f -
endef

define kustomize_delete
	kustomize build --enable-helm $(1) | kubectl delete -f -
endef
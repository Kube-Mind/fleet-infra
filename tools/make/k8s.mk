define kustomize_apply
	kustomize build --enable-helm $(1) | kubectl apply -f -
endef

define kustomize_delete
	kustomize build --enable-helm $(1) | kubectl delete -f -
endef
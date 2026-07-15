.PHONY: qdrant-setup qdrant-teardown qdrant-proxy

QDRANT_NAMESPACE=qdrant
QDRANT_PATH=src/platform/storage/qdrant
qdrant-setup:
	$(call kustomize_apply,$(QDRANT_PATH))

qdrant-proxy:
	kubectl -n $(QDRANT_NAMESPACE) port-forward pod/qdrant-0  6333:6333

qdrant-teardown:
	$(call kustomize_delete,$(QDRANT_PATH))
.PHONY: platform-core-setup platform-core-teardown

_PLATFORM_CORE_PATH = src/platform/core
platform-core-setup:
	$(call kustomize_apply,$(_PLATFORM_CORE_PATH))

platform-core-teardown:
	$(call kustomize_delete,$(_PLATFORM_CORE_PATH))

.PHONY: platform-network-setup platform-network-teardown

_PLATFORM_NETWORK_PATH = src/platform/network
platform-network-setup:
	$(call kustomize_apply,$(_PLATFORM_NETWORK_PATH))

platform-network-teardown:
	$(call kustomize_delete,$(_PLATFORM_NETWORK_PATH))

.PHONY: platform-storage-setup platform-storage-teardown

_PLATFORM_STORAGE_PATH = src/platform/network
platform-storage-setup:
	$(call kustomize_apply,$(_PLATFORM_STORAGE_PATH))

platform-storage-teardown:
	$(call kustomize_delete,$(_PLATFORM_STORAGE_PATH))
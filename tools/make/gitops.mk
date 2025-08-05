# PLATFORM APPLICATIONS
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

.PHONY: platform-observability-setup platform-observability-teardown
_PLATFORM_OBSERVABILITY_PATH = src/platform/network
platform-observability-setup:
	$(call kustomize_apply,$(_PLATFORM_OBSERVABILITY_PATH))

platform-observability-teardown:
	$(call kustomize_delete,$(_PLATFORM_OBSERVABILITY_PATH))

.PHONY: platform-security-setup platform-security-teardown
_PLATFORM_SECURITY_PATH = src/platform/security
platform-security-setup:
	$(call kustomize_apply,$(_PLATFORM_SECURITY_PATH))

platform-security-teardown:
	$(call kustomize_delete,$(_PLATFORM_SECURITY_PATH))

.PHONY: platform-storage-setup platform-storage-teardown
_PLATFORM_STORAGE_PATH = src/platform/storage
platform-storage-setup:
	$(call kustomize_apply,$(_PLATFORM_STORAGE_PATH))

platform-storage-teardown:
	$(call kustomize_delete,$(_PLATFORM_STORAGE_PATH))

.PHONY: platform-setup platform-teardown
_PLATFORM_PATH = src/platform
platform-setup:
	$(call kustomize_apply,$(_PLATFORM_PATH))

platform-teardown:
	$(call kustomize_delete,$(_PLATFORM_PATH))

# WORKLOADS APPLICATIONS
.PHONY: workloads-ci-setup workloads-ci-teardown
_WORKLOADS_CI_PATH = src/workloads/ci

workloads-ci-setup:
	$(call kustomize_apply,$(_WORKLOADS_CI_PATH))

workloads-ci-teardown:
	$(call kustomize_delete,$(_WORKLOADS_CI_PATH))

.PHONY: workloads-messaging-setup workloads-messaging-teardown
_WORKLOADS_MESSAGING_PATH = src/workloads/messaging

workloads-messaging-setup:
	$(call kustomize_apply,$(_WORKLOADS_MESSAGING_PATH))

workloads-messaging-teardown:
	$(call kustomize_delete,$(_WORKLOADS_MESSAGING_PATH))

.PHONY: workloads-ai-setup workloads-ai-teardown
_WORKLOADS_AI_PATH = src/workloads/ai

workloads-ai-setup:
	$(call kustomize_apply,$(_WORKLOADS_AI_PATH))

workloads-ai-teardown:
	$(call kustomize_delete,$(_WORKLOADS_AI_PATH))

.PHONY: workloads-setup workloads-teardown
_WORKLOADS_PATH = src/workloads/

workloads-setup:
	$(call kustomize_apply,$(_WORKLOADS_PATH))

workloads-teardown:
	$(call kustomize_delete,$(_WORKLOADS_PATH))

# MAIN ArgoCD application
.PHONY: main-setup main-teardown
_MAIN_PATH = src/

main-setup:
	kubectl apply -f src/application.yaml

main-teardown:
	kubectl delete -f src/application.yaml

# WORKLOADSS APPLICATIONS
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
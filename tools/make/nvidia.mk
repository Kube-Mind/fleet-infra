.PHONY: nvidia-setup nvidia-teardown

NVIDIA_NAMESPACE=nvidia
NVIDIA_PATH=src/platform/core/nvidia-operator
nvidia-setup:
	$(call kustomize_apply,$(NVIDIA_PATH))

nvidia-teardown:
	$(call kustomize_delete,$(NVIDIA_PATH))
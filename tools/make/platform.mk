.PHONY: platform-core-setup platform-core-teardown platform-core-wait

platform-core-setup:
	$(call kustomize_apply,src/platform/core)
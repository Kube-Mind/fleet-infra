.PHONY: system-upgrade-setup system-upgrade-clean
SYSTEM_UPGRADE_NAMESPACE=system-upgrade
SYSTEM_UPGRADE_PATH=./src/platform/core/system-upgrade
SYSTEM_UPGRADE_VALUES=$(SYSTEM_UPGRADE_PATH)/values.yaml
system-upgrade-setup:
	$(call kustomize_apply,$(SYSTEM_UPGRADE_PATH))

system-upgrade-clean:
	$(call kustomize_delete,$(SYSTEM_UPGRADE_PATH))

.PHONY: system-upgrade-plan-setup system-upgrade-plan-clean
SYSTEM_UPGRADE_PLANS_NAMESPACE=system-upgrade
SYSTEM_UPGRADE_PLANS_PATH=./src/platform/core/system-upgrade-plans
SYSTEM_UPGRADE_PLANS_VALUES=$(SYSTEM_UPGRADE_PLANS_PATH)/values.yaml
system-upgrade-plan-setup:
	$(call kustomize_apply,$(SYSTEM_UPGRADE_PLANS_PATH))

system-upgrade-plan-clean:
	$(call kustomize_delete,$(SYSTEM_UPGRADE_PLANS_PATH))

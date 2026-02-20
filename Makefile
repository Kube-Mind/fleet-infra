
MAKE_PATH = ./tools/make
# libraries
include $(MAKE_PATH)/k3d.mk
include $(MAKE_PATH)/k3s.mk
include $(MAKE_PATH)/k8s.mk
include $(MAKE_PATH)/gitops.mk

# platform applications
include $(MAKE_PATH)/authentik.mk
include $(MAKE_PATH)/argo.mk
include $(MAKE_PATH)/bao.mk
include $(MAKE_PATH)/baremetal.mk
include $(MAKE_PATH)/cilium.mk
include $(MAKE_PATH)/external-secrets.mk
include $(MAKE_PATH)/grafana.mk
include $(MAKE_PATH)/kafka.mk
include $(MAKE_PATH)/ollama.mk
include $(MAKE_PATH)/longhorn.mk
include $(MAKE_PATH)/password.mk
include $(MAKE_PATH)/stable-diffusion.mk
include $(MAKE_PATH)/traefik.mk

# private helpers
include privateRules.mk
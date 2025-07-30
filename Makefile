
MAKE_PATH = ./tools/make
# libraries
include $(MAKE_PATH)/k3d.mk
include $(MAKE_PATH)/k8s.mk
include $(MAKE_PATH)/platform.mk
include $(MAKE_PATH)/workloads.mk

# platform applications
include $(MAKE_PATH)/argo-cd.mk
include $(MAKE_PATH)/bao.mk
include $(MAKE_PATH)/grafana.mk
include $(MAKE_PATH)/ollama.mk
include $(MAKE_PATH)/longhorn.mk
include $(MAKE_PATH)/password.mk
include $(MAKE_PATH)/stable-diffusion.mk
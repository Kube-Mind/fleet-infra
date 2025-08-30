.PHONY: stable-diffusion-port-forward stable-diffusion-logs stable-diffusion-shell

SD_NAMESPACE=stable-diffusion-webui
stable-diffusion-proxy:
	kubectl -n $(SD_NAMESPACE) port-forward service/stable-diffusion-webui-git-chart 7860:7860

stable-diffusion-logs:
	kubectl -n $(SD_NAMESPACE) logs -f deployment.apps/stable-diffusion-webui

stable-diffusion-shell:
	kubectl -n $(SD_NAMESPACE) exec -ti deployment.apps/stable-diffusion-webui-git-chart -- bash

.PHONY: sd-comfyui-port-forward sd-comfyui-logs sd-comfyui-shell

sd-comfyui-port-forward:
	kubectl -n sd-comfyui port-forward service/sd-comfyui-chart 7860:80
sd-comfyui-logs:
	kubectl -n sd-comfyui logs -f statefulset.apps/sd-comfyui-chart
sd-comfyui-shell:
	kubectl -n sd-comfyui exec -ti statefulset.apps/sd-comfyui-chart -- bash
.PHONY: stable-difussion-port-forward stable-difussion-logs stable-difussion-shell

SD_NAMESPACE=stable-diffusion-webui
stable-difussion-port-forward:
	kubectl -n $(SD_NAMESPACE) port-forward service/stable-diffusion-webui 7860:7860

stable-difussion-logs:
	kubectl -n $(SD_NAMESPACE) logs -f deployment.apps/stable-diffusion-webui

stable-difussion-shell:
	kubectl -n $(SD_NAMESPACE) exec -ti deployment.apps/stable-diffusion-webui -- bash
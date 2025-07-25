.PHONY: stable-diffusion-port-forward stable-diffusion-logs stable-diffusion-shell

SD_NAMESPACE=stable-diffusion-webui
stable-diffusion-proxy:
	kubectl -n $(SD_NAMESPACE) port-forward service/stable-diffusion-webui 7860:7860

stable-diffusion-logs:
	kubectl -n $(SD_NAMESPACE) logs -f deployment.apps/stable-diffusion-webui

stable-diffusion-shell:
	kubectl -n $(SD_NAMESPACE) exec -ti deployment.apps/stable-diffusion-webui -- bash
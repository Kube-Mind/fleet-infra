.PHONY: sd-comfyui-port-forward sd-comfyui-logs sd-comfyui-shell

SD_NAMESPACE=sd-comfyui
sd-comfyui-port-forward:
	kubectl -n $(SD_NAMESPACE) port-forward service/sd-comfyui-chart 7860:80
sd-comfyui-logs:
	kubectl -n $(SD_NAMESPACE) logs -f statefulset.apps/sd-comfyui-chart
sd-comfyui-shell:
	kubectl -n $(SD_NAMESPACE) exec -ti statefulset.apps/sd-comfyui-chart -- bash
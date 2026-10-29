# kubectl -n hami port-forward service/hami-hami-webui 3000:3000
.PHONY: hami-label-nodes hami-port-formward

hami-label-nodes:
	# TODO: automate by filtering through label "nvidia.com/gpu.present=true"
	kubectl label nodes nami gpu=on
	kubectl label nodes usopp gpu=on
	kubectl label nodes franky gpu=on

hami-port-forward:
	kubectl -n hami port-forward service/hami-hami-webui 3000:3000
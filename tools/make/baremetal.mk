.PHONY: apply-netplan reset-failed
netplan-apply:
	@kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | \
		xargs -n1 -P4 -I{} sh -c 'echo "Applying netplan on {}..."; ssh {} "sudo netplan apply"'

reset-failed:
	@kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | \
		xargs -n1 -P4 -I{} sh -c 'echo "Applying reset-failed on {}..."; ssh {} "sudo systemctl reset-failed"'


.PHONY: clean-stale-rs clean-stale-volumes
clean-stale-rs:
	kubectl get rs -A -o json \
		| jq -r '.items[] \
			| select( \
				(.spec.replicas // 0) == 0 and \
				(.status.replicas // 0) == 0 and \
				(.status.readyReplicas // 0) == 0 and \
				(.status.availableReplicas // 0) == 0 and \
				((now - (.metadata.creationTimestamp | fromdate)) > (7*24*60*60)) \
			) | "kubectl delete rs -n \(.metadata.namespace) \(.metadata.name)" \
			' \
		| sh

clean-stale-volumes:
	kubectl -n longhorn get volumes -o json \
		| jq -r '.items[] \
		| select(.status.state=="detached" and .status.robustness=="unknown") \
		| .metadata.name' \
		| xargs -r kubectl -n longhorn delete volume
		
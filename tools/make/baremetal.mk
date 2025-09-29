.PHONY: apply-netplan reset-failed
netplan-apply:
	@kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | \
		xargs -n1 -P4 -I{} sh -c 'echo "Applying netplan on {}..."; ssh {} "sudo netplan apply"'

reset-failed:
	@kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | \
		xargs -n1 -P4 -I{} sh -c 'echo "Applying reset-failed on {}..."; ssh {} "sudo reset-failed"'
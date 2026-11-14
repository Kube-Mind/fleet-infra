.PHONY: bm-netplan-apply bm-reset-failed
bm-netplan-apply:
	@kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | \
		xargs -n1 -P4 -I{} sh -c 'echo "Applying netplan on {}..."; ssh {} "sudo netplan apply"'

bm-reset-failed:
	@kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | \
		xargs -n1 -P4 -I{} sh -c 'echo "Applying reset-failed on {}..."; ssh {} "sudo systemctl reset-failed"'

.PHONY: bm-get-memory bm-clean-images
bm-get-memory:
	@echo "Getting memory info from nodes..."
	for node in $(NODES_IPV4); do \
		ssh $(SSH_OPTS) $$node 'free -h'; \
	done

bm-clean-images:
	@echo "Getting memory info from nodes..."
	for node in $(NODES_IPV4); do \
		ssh $(SSH_OPTS) $$node 'sudo ctr image prune --all'; \
	done

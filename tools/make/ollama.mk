.PHONY: ollama-shell

OLLAMA_NAMESPACE=ollama
ollama-shell:
	@echo "Connecting to Ollama shell in namespace $(OLLAMA_NAMESPACE)..."
	kubectl -n $(OLLAMA_NAMESPACE) exec -it deploy/ollama -- /bin/bash

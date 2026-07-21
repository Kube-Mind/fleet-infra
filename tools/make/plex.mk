.PHONY: plex-setup plex-teardown plex-proxy

PLEX_NAMESPACE=plex
PLEX_PATH=src/home/media/plex
plex-setup:
	$(call kustomize_apply,$(PLEX_PATH))

plex-proxy:
	kubectl -n $(PLEX_NAMESPACE) port-forward pod/release-name-plex-media-server-0  32400:32400

plex-teardown:
	$(call kustomize_delete,$(PLEX_PATH))
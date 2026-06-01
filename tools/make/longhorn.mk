LONGHORN_NAMESPACE=longhorn

.PHONY: longhorn-setup longhorn-teardown longhorn-proxy longhorn-login longhorn-wait
LONGHORN_NAMESPACE=longhorn
LONGHORN_PATH=./src/platform/storage/longhorn
LONGHORN_PASSWORD=$$(kubectl -n $(LONGHORN_NAMESPACE) get secret longhorn-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
longhorn-setup:
	$(call kustomize_apply,$(LONGHORN_PATH))
	kubectl -n $(LONGHORN_NAMESPACE) delete job.batch/longhorn-uninstall

longhorn-wait:
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=longhorn-csi-plugin)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=longhorn-manager)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=csi-attacher)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=csi-provisioner)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=csi-resizer)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=csi-snapshotter)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=longhorn-driver-deployer)
	$(call k8s_wait_pods_ready,$(LONGHORN_NAMESPACE),app=longhorn-ui)

longhorn-teardown:
	$(call kustomize_delete,$(LONGHORN_PATH))

longhorn-proxy:
	kubectl -n $(LONGHORN_NAMESPACE) port-forward svc/longhorn-frontend 8081:80
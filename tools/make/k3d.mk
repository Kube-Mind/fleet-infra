.PHONY: cluster-setup cluster-teardown
CLUSTER=ha-cluster

cluster-setup:
	k3d cluster create -c simulators/k3d/$(CLUSTER).yaml
cluster-start:
	k3d cluster start $(CLUSTER)
cluster-stop:
	k3d cluster stop $(CLUSTER)
cluster-teardown:
	k3d cluster delete -c simulators/k3d/$(CLUSTER).yaml
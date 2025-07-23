.PHONY: cluster-setup cluster-teardown
CLUSTER=ha-cluster

k3d-setup:
	k3d cluster create -c simulators/k3d/$(CLUSTER).yaml
k3d-start:
	k3d cluster start $(CLUSTER)
k3d-stop:
	k3d cluster stop $(CLUSTER)
k3d-teardown:
	k3d cluster delete -c simulators/k3d/$(CLUSTER).yaml
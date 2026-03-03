

# Variables (override on CLI as needed)
IPV4        ?= 
API_SERVER_IP ?= 
TOKEN       ?= `ssh cloudy@$(API_SERVER_IP) sudo -S cat /var/lib/rancher/k3s/server/node-token`
SSH_OPTS    ?= -o StrictHostKeyChecking=no
.PHONY: control-plane-init control-plane-join worker-join control-plane-get-config control-plane-bootstrap

# --bind-address=0.0.0.0' listen to any interface to allow joining nodes to connect to API server
# control-plane-init
# cilium-setup
# control-plane-join
# worker-join
# longhorn-setup
# traefik-setup
# bao-setup
# argocd-setup
# platform-security-setup
# platform-core-setup
# platform-setup

control-plane-init:
	@echo "Initializing controller node at $(API_SERVER_IP)..."
	ssh $(SSH_OPTS) $(API_SERVER_IP) 'sudo curl -sfL https://get.k3s.io | sh -s - server \
		--cluster-init \
		--bind-address=${API_SERVER_IP} \
		--node-ip=$(API_SERVER_IP) \
		--advertise-address=$(API_SERVER_IP) \
		--flannel-backend=none \
		--disable servicelb --disable-network-policy --disable traefik'

echo-token:
	@echo "TOKEN: $(TOKEN)"

KUBECONFIG ?= ~/.kube/config
control-plane-get-config:
	@echo "Retrieving K3s config from $(API_SERVER_IP)..."
	rsync --rsync-path="sudo rsync" $(API_SERVER_IP):/etc/rancher/k3s/k3s.yaml $(KUBECONFIG)

control-plane-bootstrap: control-plane-init control-plane-get-config cilium-setup
	kubectl get pods -A

# NOTE: TOKEN must be manually provided
# /etc/cloud/cloud.cfg.d/90-installer-network.cfg
control-plane-join:
	@echo "$(IPV4) Joining control plane node at $(API_SERVER_IP)..."
	ssh $(SSH_OPTS) $(IPV4) 'sudo curl -sfL https://get.k3s.io | \
	K3S_URL=https://$(API_SERVER_IP):6443 \
	K3S_TOKEN=$(TOKEN) \
	sh -s - server \
	--flannel-backend=none \
	--disable-network-policy \
	--disable servicelb \
	--disable-network-policy \
	--disable traefik \
	--node-ip=$(IPV4) \
	--bind-address $(IPV4)'

# NOTE: TOKEN must be manually provided
worker-join:
	@echo "Joining worker node at $(IPV4)..."
	ssh $(SSH_OPTS) $(IPV4) 'sudo curl -sfL https://get.k3s.io | sh -s - agent \
	--token "$(TOKEN)" --server "https://$(API_SERVER_IP):6443" --bind-address=$(IPV4)'

.PHONY: label-workers label-upgrade label-all

label-workers:
	kubectl label node  usopp node-role.kubernetes.io/worker=true
	kubectl label node  nami  node-role.kubernetes.io/worker=true
	kubectl label node  franky  node-role.kubernetes.io/worker=true

label-upgrade:
	kubectl label node  luffy  k3s-upgrade=true
	kubectl label node  zoro   k3s-upgrade=true
	kubectl label node  sanji  k3s-upgrade=true
	kubectl label node  usopp  k3s-upgrade=true
	kubectl label node  nami   k3s-upgrade=true
	kubectl label node  franky k3s-upgrade=true

label-all: label-workers label-upgrade

.PHONY: taint-control-plane
taint-control-plane:
	kubectl taint node fenrir node-role.kubernetes.io/control-plane=true:NoSchedule
	kubectl taint node bohr node-role.kubernetes.io/control-plane=true:NoSchedule
	kubectl taint node tyr node-role.kubernetes.io/control-plane=true:NoSchedule


# Variables (override on CLI as needed)
IPV4        ?= 
API_SERVER_IP ?= 
TOKEN       ?= $(shell ssh cloudy@$(API_SERVER_IP) sudo -S cat /var/lib/rancher/k3s/server/node-token)
SSH_OPTS    ?= -o StrictHostKeyChecking=no
.PHONY: k3s-cp-init k3s-cp-join k3s-worker-join k3s-cp-get-config k3s-cp-bootstrap

KUBECONFIG ?= ~/.kube/config
k3s-cp-get-config:
	@echo "Retrieving K3s config from $(API_SERVER_IP)..."
	rsync --rsync-path="sudo rsync" $(API_SERVER_IP):/etc/rancher/k3s/k3s.yaml $(KUBECONFIG)

# --bind-address=0.0.0.0' listen to any interface to allow joining nodes to connect to API server
# k3s-cp-init
# cilium-setup
# k3s-cp-join
# worker-join
# longhorn-setup
# bao-setup
# external-secrets-setup
# secrets-integrator-setup
# cert-manager-setup
# letsencrypt-setup
# authentik-setup
# argocd-setup
# platform-security-setup
# platform-core-setup
# platform-setup

k3s-cp-init:
	@echo "Initializing controller node at $(API_SERVER_IP)..."
	ssh $(SSH_OPTS) $(API_SERVER_IP) 'sudo curl -sfL https://get.k3s.io | sh -s - server \
		--cluster-init \
		--bind-address=${API_SERVER_IP} \
		--node-ip=$(API_SERVER_IP) \
		--advertise-address=$(API_SERVER_IP) \
		--flannel-backend=none \
		--disable=servicelb \
		--disable=traefik \
		--disable-network-policy'
	$(MAKE) k3s-cp-get-config

.PHONY: k3s-echo-token
k3s-echo-token:
	@echo "TOKEN: $(TOKEN)"

k3s-cp-bootstrap: k3s-cp-init k3s-cp-get-config cilium-setup
	kubectl get pods -A

# NOTE: TOKEN must be manually provided
# /etc/cloud/cloud.cfg.d/90-installer-network.cfg
k3s-cp-join:
	$(call k3s_cp_join,$(API_SERVER_IP),$(IPV4),$(TOKEN))
	

# NOTE: TOKEN must be manually provided
k3s-worker-join:
	@echo "Joining worker node at $(IPV4)..."
	ssh $(SSH_OPTS) $(IPV4) 'sudo curl -sfL https://get.k3s.io | sh -s - agent \
	--token "$(TOKEN)" --server "https://$(API_SERVER_IP):6443" --bind-address=$(IPV4)'

.PHONY: k3s-label-workers k3s-label-upgrade k3s-label-all

k3s-label-workers:
	kubectl label node  usopp node-role.kubernetes.io/worker=true
	kubectl label node  nami  node-role.kubernetes.io/worker=true
	kubectl label node  franky  node-role.kubernetes.io/worker=true

k3s-label-upgrade:
	kubectl label node  luffy  k3s-upgrade=true
	kubectl label node  zoro   k3s-upgrade=true
	kubectl label node  sanji  k3s-upgrade=true
	kubectl label node  usopp  k3s-upgrade=true
	kubectl label node  nami   k3s-upgrade=true
	kubectl label node  franky k3s-upgrade=true

k3s-label-all: k3s-label-workers k3s-label-upgrade

.PHONY: k3s-cp-taint
k3s-cp-taint:
	kubectl taint node luffy node-role.kubernetes.io/control-plane=true:NoSchedule

define k3s_cp_join
	@echo "$(2) Joining control plane node at $(1)..."
	ssh $(SSH_OPTS) $(2) 'sudo curl -sfL https://get.k3s.io | \
	K3S_URL=https://$(1):6443 \
	K3S_TOKEN=$(3) \
	sh -s - server \
	--bind-address=$(2) \
	--node-ip=$(2) \
	--advertise-address=$(2) \
	--flannel-backend=none \
	--disable=servicelb \
	--disable=traefik \
	--disable-network-policy'
endef

define k3s_worker_join
	@echo "$(2) Joining worker node at $(1)..."
	ssh $(SSH_OPTS) $(2) 'sudo curl -sfL https://get.k3s.io | sh -s - agent \
	--token "$(3)" --server "https://$(1):6443" --bind-address=$(2)'
endef
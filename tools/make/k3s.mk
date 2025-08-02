

# Variables (override on CLI as needed)
IPV4        ?= 10.1.1.14
API_SERVER_IP ?= 10.1.1.14
TOKEN       ?= `ssh cloudy@$(API_SERVER_IP) sudo -S cat /var/lib/rancher/k3s/server/node-token`
SSH_OPTS    ?= -o StrictHostKeyChecking=no
.PHONY: echo-token join-control-plane join-worker init-controller label-workers

init-controller:
	@echo "Initializing controller node at $(IPV4)..."
	ssh $(SSH_OPTS) $(IPV4) 'sudo curl -sfL https://get.k3s.io | sh -s - \
      --flannel-backend=none \
      --disable-kube-proxy \
      --disable servicelb \
      --disable-network-policy \
      --disable traefik \
      --cluster-init --bind-address=${API_SERVER_IP}'

echo-token:
	@echo "TOKEN: $(TOKEN)"

get-k3s-config:
	@echo "Retrieving K3s config from $(IPV4)..."
	rsync --rsync-path="sudo rsync" $(IPV4):/etc/rancher/k3s/k3s.yaml $(KUBECONFIG)

join-control-plane:
	@echo "$(IPV4) Joining control plane node at $(API_SERVER_IP)..."
	ssh $(SSH_OPTS) $(IPV4) 'sudo curl -sfL https://get.k3s.io | \
	K3S_URL=https://$(API_SERVER_IP):6443 \
	K3S_TOKEN=$(_K3S_TOKEN) \
	sh -s - server \
	--flannel-backend=none \
	--disable-network-policy \
	--cluster-init --bind-address $(IPV4)'


join-worker:
	@echo "Joining worker node at $(IPV4)..."
	ssh $(SSH_OPTS) $(IPV4) 'sudo curl -sfL https://get.k3s.io | sh -s - agent \
	--token "$(_K3S_TOKEN)" --server "https://$(API_SERVER_IP):6443" --bind-address=$(IPV4)'

# kubectl label node  baldr  k3s-upgrade=true
# kubectl label node  fenrir k3s-upgrade=true
# kubectl label node  loki   k3s-upgrade=true
# kubectl label node  odin   k3s-upgrade=true
# kubectl label node  tyr    k3s-upgrade=true
label-workers:
	kubectl label node  baldr node-role.kubernetes.io/worker=true
	kubectl label node  odin  node-role.kubernetes.io/worker=true
	kubectl label node  turing  node-role.kubernetes.io/worker=true
# NOTES

## Cluster BOOTSTRAP

### K3s installation

#### Initial control plane node

```bash
# install k3s control plane
## Flags as follows
### --flannel-backend=none 
### --disable-kube-proxy 
### --disable servicelb 
### --disable-network-policy 
### --disable traefik 
### --cluster-init 
### --bind-address=${API_SERVER_IP} 
make init-controller

# confirm token existence
make echo-token

# procure k3s config
make get-k3s-config
```

#### add control plane nodes to cluster

```bash
read _IPV4
read _TOKEN
make join-control-plane IPV4=${_IPV4} TOKEN=${_TOKEN}
```

#### add worker nodes to cluster

```bash
read _IPV4
read _TOKEN
make join-control-plane IPV4=${_IPV4} TOKEN=${_TOKEN}
```
# ETCD

This document registers known scenarios where the k3s ETCD cluster is in an unhealthy state.

1. [Stale node configuration exists node]()


## Prerequisites

### Assumptions

- Persistent volumes have 3 replictions at rest through Longhorn
- n-1 etcd are in an operational state
- baremetal server is accessible at through the primary or backup NIC

### Preliminary investigation

Confirm healthy and unhealthy k3s control plane nodes. In the provided example, luffy is in an unhealthy state.

```bash
kubectl get nodes
NAME     STATUS                        ROLES                AGE   VERSION
franky   Ready                         <none>               20d   v1.34.3+k3s3
luffy    NotReady,SchedulingDisabled   control-plane,etcd   20d   v1.34.3+k3s3
nami     Ready                         <none>               20d   v1.34.3+k3s3
sanji    Ready                         control-plane,etcd   20d   v1.34.3+k3s3
usopp    Ready                         <none>               20d   v1.34.3+k3s3
zoro     Ready                         control-plane,etcd   20d   v1.34.3+k3s3
```

## Stale node configuration exists node

### Known causes

- CNI configuration updated, etcd communication blocked. Rolled back CNI configuration, 1/3 etcd cluster communication bloced. Deleted node from cluster, cleaned baremetal ip routes. Reinstalled k3s to rejoin cluster. systemd process failed

### Investigation process

Within the unhealthy server, investigate errors logged through the systemd process

```bash
journalctl -xe
Mar 05 20:00:01 luffy k3s[9269]: I0305 20:00:01.029378    9269 options.go:305] unable to set WatchListClient feature gate, err: cannot override default for >
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="Running cloud-controller-manager --allocate-node-cidrs=true --authentication-ku>
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="Server node token is available at /var/lib/rancher/k3s/server/token"
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="To join server node to cluster: k3s server -s https://172.16.1.14:6443 -t ${SER>
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="Agent node token is available at /var/lib/rancher/k3s/server/agent-token"
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="To join agent node to cluster: k3s agent -s https://172.16.1.14:6443 -t ${AGENT>
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="Wrote kubeconfig /etc/rancher/k3s/k3s.yaml"
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=info msg="Run: k3s kubectl"
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=error msg="Sending HTTP/1.1 503 response to 127.0.0.1:49326: runtime core not ready"
Mar 05 20:00:01 luffy k3s[9269]: time="2026-03-05T20:00:01Z" level=error msg="Shutdown request received: etcd cluster join failed: duplicate node name found>
```

The line of interest consist of `Shutdown request received: etcd cluster join failed: duplicate node name found>`

### Solution

The Immediate solution os to directly tap in into the etcd configurations and manually delete the stale configuration.

```bash
# Install and validate ETCD client binary
export ETCD_VER=v3.5.5
curl -sL https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz \
  -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

## extract only etcdctl
sudo tar -zxvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
  --strip-components=1 -C /usr/local/bin etcd-${ETCD_VER}-linux-amd64/etcdctl

## verify it runs
etcdctl version
etcd-v3.5.5-linux-amd64/etcdctl
etcdctl version: 3.5.5
API version: 3.5

## Confirm etcd members
etcdctl \
  --cacert=/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt \
  --cert=/var/lib/rancher/k3s/server/tls/etcd/client.crt \
  --key=/var/lib/rancher/k3s/server/tls/etcd/client.key \
  --endpoints=https://127.0.0.1:2379 \
  member list
119ae38c325c9e8c, started, luffy-70f8ccd7, https://172.16.1.14:2380, https://172.16.1.14:2379, false
13beb1c6c694385b, started, zoro-7cbd5f16, https://172.16.1.15:2380, https://172.16.1.15:2379, false
474f260c75e58caa, started, sanji-a46ff39a, https://172.16.1.16:2380, https://172.16.1.16:2379, false
```

The entry involving luffy confirms that a stale configuration exists if k3s-uninstall.sh was executed in the baremetal OS and when kubectl delete node luffy was executed against an operational k3s control plane node.

The following steps involves the deleteion of the stale configuration.

```bash
etcdctl \
  --cacert=/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt \
  --cert=/var/lib/rancher/k3s/server/tls/etcd/client.crt \
  --key=/var/lib/rancher/k3s/server/tls/etcd/client.key \
  --endpoints=https://127.0.0.1:2379 \
  member remove 119ae38c325c9e8c
Member 119ae38c325c9e8c removed from cluster  cbb7dd375fec59d
```
# INSTALLATION

This documentation contains the instructions for bootstrapping baremetal servers leading to an operational k3s cluster managed using GitOps methodology through ArgoCD.

## Prerequisites

- [x] Operational baremetal Ubuntu servers
- [x] Control plane nodes
- [x] GPU Worker nodes
- [x] Internet access
- [x] BPF binaries for Cilium CNI

        sudo apt update -y && \
        sudo apt install -y   \
        linux-headers-$(uname -r)   \
        linux-tools-$(uname -r)   \
        libbpf1   \
        iproute2   \
        iptables   \
        clang   \
        llvm && \
        sudo apt upgrade -y && \
        sudo apt autoremove -y

- [x] k3s optimised kernel configurations.
- [x] multipathd config for longhorn CSI. See https://longhorn.io/kb/troubleshooting-volume-with-multipath/
- [x] configure physical disks for longhorn utilisation

        # Get disk path
        lsblk
        read DISK_PATH
        echo $DISK_PATH

        # Format disk with GPT
        fdisk $DISK_PATH
        n
        g
        w

        # Create mount point
        mkdir -p /mnt/disk1
        mkfs.ext4 $DISK_PATH

        # Capture device block UUID
        blkid
        read DEVICE_UUID
        echo $DEVICE_UUID
        # Write configuration to fstab
        echo "UUID=\"$DEVICE_UUID\" /mnt/disk1  ext4  defaults  0 0" >> /etc/fstab
        mount -a

- [x] nfs client binaries for longhorn backups

        sudo apt update -y && sudo apt install -y nfs-common

## Installation

- [x] Install k3s as a server at the selected initial control plane

        # load IP of the selected server
        read _API_SERVER_IP
        k3s-cp-init API_SERVER_IP=$_API_SERVER_IP
        # confirm that k8s API is reachable
        kubectl get nodes

- [x] Confirm that k3s join token is obtainable

        make k3s-echo-token

- [x] Install Cilium CNI

        # Install Cilium through helm + kustomize
        make cilium-setup
        # Wait for Cilium installation
        make cilium-wait

- [x] Join selected server to initial control plane as also control plane nodes for high availability

        # Load IP of the selected server. Keep repeating until all intended servers are joined
        read _IPV4
        k3s-cp-join IPV4=$_IPV4

- [x] Join selected server to initial control plane as worker nodes for high availability

        # Load IP of the selected server. Keep repeating until all intended servers are joined
        read _IPV4
        k3s-worker IPV4=$_IPV4

- [x] Install Longhorn CSI

        # Install Longhorn through helm + kustomize
        make longhorn-setup
        # Wait for Longhorn installation
        make longhorn-wait

- [x] Configure Longhorn to utilise additional disks

        # Proxy to the longhorn WebUI
        make longhorn-proxy
        # Navigate to Nodes>edit nodes and disks (far right drop down on node rows)>add disk

- [x] Install openbao

        # Install OpenBao through helm + kustomize
        make bao-setup
        # Wait for OpenBao installation
        make bao-wait
        # Initialise OpenBao server. Store Openbao server credentials to a secure storage
        make bao-init
        # Unseal OpenBao server. Procure seal keys from Openbao server credentials
        make bao-unseal 
        # Login to OpenBao server. Procure login token from Openbao server credentials
        make bao-login
        # Enable secret engines
        make bao-kv-enable
        # Populate OpenBao for External secrets + secrets integrator integration

- [x] Install External secrets

        # Install external secrets
        make external-secrets-setup

- [x] Install Secrets integrator

        # Install secrets integrator through helm + kustomize
        make secrets-integrator-setup
        # Get resources
        make secrets-integrator-get-resources
        # Generate token
        make secrets-integrator-create-token

- [x] Install Letsencrypt Certificate Issuer

        # Install letsencrypt through helm + kustomize
        make letsencrypt-setup
        # Get letsencrypt resources
        make letsencrypt-get-resources

- [x] Install Authentik for application SSO

        # Install Authentik through helm + kustomize
        make authentik-setup
        # Wait for Authentik pods
        make authentik-wait

- [x] Install ArgoCD

        # Install ArgoCD through helm + kustomize
        make argocd-setup
        # Wait for ArgoCD pods
        make argocd-wait

- [x] GitOps installation

        platform-core-setup
        platform-observability-setup
        platform-network-setup
        platform-storage-setup
        platform-setup
        make main-setup
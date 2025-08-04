# Platform ⚙️

The platform layer consists of core infrastructure components that provide a **stable, secure, and extensible foundation** for Kubernetes clusters. All applications are deployed and managed using GitOps principles via Argo CD.

> ℹ️ All applications are declaratively managed using the [ApplicationSet](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/) controller, ensuring consistent and automated deployment across environments.

## 📑 Table of Contents

- [🧱 platform-core](#platform-core-)
- [🌐 platform-network](#platform-network-)
- [📊 platform-observability](#platform-observability-)
- [🔐 platform-security](#platform-security-)
- [📦 platform-storage](#platform-storage-)

| Name | Status | Description |
| ---- | ------ | ----------- |
| [platform-core](./src/platform/core) | ![platform-core](https://cd.jcan.dev/api/badge?name=platform-core&revision=true&showAppName=true) | Installs critical cluster components such as Argo CD, ingress controllers, certificate managers, and other foundational tools. |
| [platform-network](./src/platform/network) | ![platform-network](https://cd.jcan.dev/api/badge?name=platform-network&revision=true&showAppName=true) | Manages networking components including CNI plugins, MetalLB, Traefik ingress, and automatic DNS and TLS configuration. |
| [platform-observability](./src/platform/observability) | ![platform-observability](https://cd.jcan.dev/api/badge?name=platform-observability&revision=true&showAppName=true) | Provides monitoring, logging, and alerting via Prometheus, Grafana, and related telemetry tools. |
| [platform-security](./src/platform/security) | ![platform-security](https://cd.jcan.dev/api/badge?name=platform-security&revision=true&showAppName=true) | Deploys security tooling for authentication, secrets management, and policy enforcement. |
| [platform-storage](./src/platform/storage) | ![platform-storage](https://cd.jcan.dev/api/badge?name=platform-storage&revision=true&showAppName=true) | Manages persistent storage provisioners, container registries, and CSI drivers for stateful workloads. |

> [🔝 Back to top](#-table-of-contents)
---

## platform-core 🧱

The `platform-core` group bootstraps essential infrastructure that enables GitOps workflows, certificate automation, GPU scheduling, and cluster upgrades.

| Component | Status | Description |
|-----------|--------|-------------|
| **argo-cd** | ![argo-cd](https://cd.jcan.dev/api/badge?name=argo-cd&revision=true&showAppName=true) | [Argo CD](https://argo-cd.readthedocs.io/) is the GitOps controller that continuously reconciles cluster state from Git repositories. |
| **cert-manager** | ![cert-manager](https://cd.jcan.dev/api/badge?name=cert-manager&revision=true&showAppName=true) | [cert-manager](https://cert-manager.io/) automates TLS certificate issuance and renewal using ACME (Let's Encrypt) or internal CAs. |
| **external-secrets** | ![external-secrets](https://cd.jcan.dev/api/badge?name=external-secrets&revision=true&showAppName=true) | Syncs secrets from external secret managers (e.g., AWS Secrets Manager, Vault) into Kubernetes secrets. |
| **nvidia-operator** | ![nvidia-operator](https://cd.jcan.dev/api/badge?name=nvidia-operator&revision=true&showAppName=true) | Deploys the NVIDIA GPU Operator to manage GPU drivers, device plugins, and MIG configuration. |
| **system-upgrade** | ![system-upgrade](https://cd.jcan.dev/api/badge?name=system-upgrade&revision=true&showAppName=true) | Installs the system upgrade controller for orchestrating safe K3s or RKE2 upgrades. |
| **system-upgrade-plans** | ![system-upgrade-plans](https://cd.jcan.dev/api/badge?name=system-upgrade-plans&revision=true&showAppName=true) | Defines upgrade plans specifying Kubernetes versions and channels for automated upgrades. |

> [🔝 Back to top](#-table-of-contents)
---

## platform-network 🌐

The `platform-network` group configures Kubernetes networking infrastructure, including CNI, L2/L3 load balancing, ingress, and DNS resolution.

| Component | Status | Description |
|-----------|--------|-------------|
| **dnsfix** | ![dnsfix](https://cd.jcan.dev/api/badge?name=dnsfix&revision=true&showAppName=true) | Applies DNS patches and workarounds to ensure reliable name resolution within the cluster. |
| **cilium** | ![cilium](https://cd.jcan.dev/api/badge?name=cilium&revision=true&showAppName=true) | [Cilium](https://cilium.io/) is a high-performance CNI plugin providing networking, observability, and security policies. |
| **letsencrypt** | ![letsencrypt](https://cd.jcan.dev/api/badge?name=letsencrypt&revision=true&showAppName=true) | Configures ACME issuers to enable automatic TLS certificates via cert-manager. |
| **metallb** | ![metallb](https://cd.jcan.dev/api/badge?name=metallb&revision=true&showAppName=true) | [MetalLB](https://metallb.universe.tf/) provides a load balancer implementation for bare-metal clusters. |
| **traefik** | ![traefik](https://cd.jcan.dev/api/badge?name=traefik&revision=true&showAppName=true) | [Traefik](https://traefik.io/) is an ingress controller and edge router for routing HTTP/S traffic. |

> [🔝 Back to top](#-table-of-contents)
---

## platform-observability 📊

The `platform-observability` group delivers monitoring, alerting, and visualization capabilities to maintain cluster health and performance.

| Component | Status | Description |
|-----------|--------|-------------|
| **kube-prometheus-stack** | ![kube-prometheus-stack](https://cd.jcan.dev/api/badge?name=kube-prometheus-stack&revision=true&showAppName=true) | Deploys the [Prometheus Operator](https://github.com/prometheus-operator/kube-prometheus) stack, including Prometheus, Alertmanager, Grafana, and exporters. |

> [🔝 Back to top](#-table-of-contents)
---

## platform-security 🔐  

The `platform-security` group provides authentication, secret management, and policy controls to secure workloads and access.

| Component | Status | Description |
|-----------|--------|-------------|
| **authentik** | ![authentik](https://cd.jcan.dev/api/badge?name=authentik&revision=true&showAppName=true) | [Authentik](https://goauthentik.io/) is an identity provider supporting OAuth2, SAML, and LDAP for single sign-on. |
| **openbao** | ![openbao](https://cd.jcan.dev/api/badge?name=openbao&revision=true&showAppName=true) | [OpenBao](https://openbao.dev/) (a community fork of HashiCorp Vault) manages secrets, encryption keys, and dynamic credentials. |
| **secrets-integrator** | ![secrets-integrator](https://cd.jcan.dev/api/badge?name=secrets-integrator&revision=true&showAppName=true) | Bridges external secret stores with Kubernetes-native secrets for consistent secret delivery. |

> [🔝 Back to top](#-table-of-contents)
---

## platform-storage 📦

The `platform-storage` group installs persistent storage provisioners, registries, and volume managers for stateful workloads.

| Component | Status | Description |
|-----------|--------|-------------|
| **harbor** | ![harbor](https://cd.jcan.dev/api/badge?name=harbor&revision=true&showAppName=true) | [Harbor](https://goharbor.io/) is a cloud-native container registry with vulnerability scanning, RBAC, and replication support. |
| **longhorn** | ![longhorn](https://cd.jcan.dev/api/badge?name=longhorn&revision=true&showAppName=true) | [Longhorn](https://longhorn.io/) provides distributed block storage with snapshots and backups for Kubernetes. |
| **nfs-provisioner** | ![nfs-provisioner](https://cd.jcan.dev/api/badge?name=nfs-provisioner&revision=true&showAppName=true) | A dynamic provisioner for providing NFS-backed persistent volumes across pods. |

> [🔝 Back to top](#-table-of-contents)

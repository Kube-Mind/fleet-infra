# fleet-infra

The fleet infrastructure repository consists of curated open source applications dedicated to cluster bootstrapping and providing a robust platform characterized by [GitOps](https://opengitops.dev/about) principles, the [ArgoCD app of apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern), and [Kubernetes native](https://landscape.cncf.io/) architecture.

## Key Features

- **GitOps Driven:** Embrace the GitOps methodology for declarative configuration management and continuous delivery of infrastructure changes.
- **ArgoCD App of Apps Pattern:** Leverage the power of ArgoCD's app of apps pattern for efficient and scalable application deployment and management.
- **Kubernetes Native:** Harness the full potential of Kubernetes, ensuring seamless integration and optimal performance within your infrastructure. Referencing the [CNCF Trailmap](https://landscape.cncf.io/), our suite aligns with industry best practices and standards for cloud-native infrastructure.

## Application Projects

The applications are categorised through ArgoCD's [Application Projects](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/), each designed to fulfill specific roles and functionalities within the infrastructure ecosystem:

| Name | Status | Description |
| ---- | ------ | ----------- |
| [main](./src/main/values.yaml) | ![fleet-infra](https://cd.jcan.dev/api/badge?name=main&revision=true&showAppName=true) | Core components and configurations |
| [infra-management](./src/projects/values.infra-management.yaml) | ![infra-management](https://cd.jcan.dev/api/badge?name=infra-management&revision=true&showAppName=true) | Applications for managing Kubernetes infrastructure resources. |
| [infra-operations](./src/projects/values.infra-operations.yaml) | ![infra-operations](https://cd.jcan.dev/api/badge?name=infra-operations&revision=true&showAppName=true) | Applications for streamlining cluster operations. |
| [infra-monitoring](./src/projects/values.infra-monitoring.yaml) | ![infra-monitoring](https://cd.jcan.dev/api/badge?name=infra-monitoring&revision=true&showAppName=true) | Applications for monitoring Kubernetes infrastructure. |
| [dev-management](./src/projects/values.dev-management.yaml) | ![dev-management](https://cd.jcan.dev/api/badge?name=dev-management&revision=true&showAppName=true) | Development tools management |
| [dev-operations](./src/projects/values.infra-operations.yaml) | ![dev-operations](https://cd.jcan.dev/api/badge?name=dev-operations&revision=true&showAppName=true) | Applications for streamlining development tools operations. |
| [kmind-management](./src/projects/values.infra-operations.yaml) | ![kmind-management](https://cd.jcan.dev/api/badge?name=kmind-management&revision=true&showAppName=true) | In house applications. |
| [work](./src/projects/values.infra-operations.yaml) | ![work](https://cd.jcan.dev/api/badge?name=work&revision=true&showAppName=true) | Tools and dependencies used for work. |
||||

## Tools

| Name | Description |
| --- | --- |
| [ArgoCD](./docs/make/argo-cd.md) | GitOps tool used for managing k8s clusters. |
| [k3d](./docs/make/k3d.md) | K3s in docker. Used for simulating k8s clusters. |

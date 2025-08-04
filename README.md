# fleet-infra

The fleet infrastructure repository consists of curated open source applications dedicated to cluster bootstrapping and providing a robust platform characterized by [GitOps](https://opengitops.dev/about) principles, the [ArgoCD app of apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern), and [Kubernetes native](https://landscape.cncf.io/) architecture.

## Key Features

- **GitOps Driven:** Embrace the GitOps methodology for declarative configuration management and continuous delivery of infrastructure changes.
- **ArgoCD App of Apps Pattern:** Leverage the power of ArgoCD's app of apps pattern for efficient and scalable application deployment and management.
- **Kubernetes Native:** Harness the full potential of Kubernetes, ensuring seamless integration and optimal performance within your infrastructure. Referencing the [CNCF Trailmap](https://landscape.cncf.io/), our suite aligns with industry best practices and standards for cloud-native infrastructure.

## Application Groups

The applications are categorised through ArgoCD's [Application Projects](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/), each designed to fulfill specific roles and functionalities within the infrastructure ecosystem:

| Name | Status | Description |
| ---- | ------ | ----------- |
| [main](./src/application.yaml) | ![fleet-infra](https://cd.jcan.dev/api/badge?name=main&revision=true&showAppName=true) | Entrypoint application. Owns top level applications. |
| [platform](./docs/PLATFORM.md) | ![platform](https://cd.jcan.dev/api/badge?name=platform&revision=true&showAppName=true) | Top level application that owns platform and infrastructure management applications. |
| [workloads](./docs/WORKLOADS.md) | ![workloads](https://cd.jcan.dev/api/badge?name=workloads&revision=true&showAppName=true) | Top level application that owns software services. |

# TODO

## ArgoCD App of Apps Migration Reference

This document serves as a reference for the migration of applications in our custom ArgoCD app of apps pattern. The following table lists each application's migration status, name, original path, and new path.

### Migration Table

| Migrated | App Name                    | Original Path                                                         | New Path                                                   |
|----------|-----------------------------|-----------------------------------------------------------------------|------------------------------------------------------------|
|   True   | github-scale-set            | configurations/dev-management/github-scale-set                        | workloads/ci/github-runner/gha-runner-scale-set            |
|   True   | github-scale-set-controller | configurations/dev-management/github-scale-set-controller             | workloads/ci/github-runner/gha-runner-scale-set-controller |
|   True   | gitlab-runner               | configurations/dev-management/gitlab-runner                           | workloads/ci/gitlab-runner                                 |
|   True   | harbor                      | configurations/dev-management/harbor                                  | platform/storage/harbor                                    |
|   True   | jupyterhub                  | configurations/dev-management/jupyterhub                              | workloads/tools/jupyterhub                                 |
|   True   | kafka                       | configurations/dev-management/kafka                                   | workloads/messaging/kafka                                  |
|   True   | n8n                         | configurations/dev-management/n8n                                     | workloads/tools/n8n                                        |
|   True   | ollama                      | configurations/dev-management/ollama                                  | workloads/ai/ollama                                        |
|   True   | rabbitmq                    | configurations/dev-management/rabbitmq                                | workloads/messaging/rabbitmq                               |
|   True   | traefik-runtime-configs     | configurations/dev-operations/traefik-runtime-configs                 | platform/storage/harbor/configs/traefik                    |
|   True   | argo-cd                     | configurations/infra-management/argo-cd                               | platform/core/argo-cd                                      |
|   True   | cert-manager                | configurations/infra-management/cert-manager                          | platform/core/cert-manager                                 |
|   True   | cilium                      | configurations/infra-management/cilium                                | platform/network/cilium                                    |
|   True   | external-secrets            | configurations/infra-management/external-secrets                      | platform/core/external-secrets                             |
|   True   | k3s-upgrader                | configurations/infra-management/k3s-upgrader                          | platform/core/system-upgrade                               |
|   True   | longhorn                    | configurations/infra-management/longhorn                              | platform/storage/longhorn                                  |
|   True   | metallb                     | configurations/infra-management/metallb                               | platform/network/metallb                                   |
|   True   | nfs-provisioner             | configurations/infra-management/nfs-provisioner                       | platform/storage/nfs-provisioner                           |
|   True   | nvidia-operator             | configurations/infra-management/nvidia-operator                       | platform/core/nvidia-operator                              |
|   True   | openbao                     | configurations/infra-management/openbao                               | platform/security/openbao                                  |
|   True   | traefik                     | configurations/infra-management/traefik                               | platform/network/traefik                                   |
|   True   | kube-prometheus-stack       | configurations/infra-monitoring/kube-prometheus-stack                 | platform/observability/kube-prometheus-stack               |
|   True   | k3s-upgrader-plans          | configurations/infra-operations/k3s-upgrader-plans                    | platform/core/system-upgrade-plans                         |
|   True   | letsencrypt                 | configurations/infra-operations/letsencrypt                           | platform/network/letsencrypt                               |
|   True   | metallb-runtime-configs     | configurations/infra-operations/metallb-runtime-configs               | src/platform/network/metallb/configs                       |
|   True   | secrets-integrator          | configurations/infra-operations/secrets-integrator                    |                                                            |
|    N/A   | chartwatch                  | configurations/kmind-management/chartwatch                            |                                                            |
|   True   | dnsfix                      | configurations/kmind-management/dnsfix                                | platform/network/dnsfix                                    |
|   True   | open-webui                  | configurations/kmind-management/open-webui                            | workloads/ai/open-webui                                    |
|   True   | stable-diffusion-webui      | configurations/kmind-management/stable-diffusion-webui                | workloads/ai/table-diffusion-webui                         |
|          | pft                         | configurations/work/pft                                               |                                                            |
|          | ska                         | configurations/work/ska                                               |                                                            |

### Instructions for Migration

1. **Review the Table**: Check which applications have been migrated and their corresponding paths.
2. **Update Paths**: For each application, update your configurations to reflect the new paths as necessary.
3. **Test Changes**: Ensure that you test each updated configuration to verify that everything works correctly in the new setup.

This document will be updated periodically to reflect changes in migration status and to provide any additional context or instructions related to the process.

### prereq

1. teardown cluster
2. reboot nodes as needed

### Order of execution

1. Initialise k3s control plain nodes
2. Initialise k3s worker nodes
3. Install Cilium
4. Install ArgoCD, Longhorn
5. Update longhorn settings concerning mounts
6. Install GitOps main application

## Update networking policy for jupyterlab

see: https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues/3202

- [ ] rollback

        hub:
            networkPolicy:
                egress:
                - ports:
                    - port: 6443

- [ ] implement

        apiVersion: cilium.io/v2
        kind: CiliumNetworkPolicy
        metadata:
            name: allow-access-to-api-server
            namespace: jupyterhub-test
        spec:
            egress:
            - toEntities:
                - kube-apiserver
            endpointSelector:
                matchLabels:
                app: jupyterhub
                component: hub

timeline:
- migrate app-of-apps to app-sets
- implement authentik
- proceed with stable-diffusion course (learn how to create image, music, videos workflows)
- update github profile
- start youtube channel - content creation on the following
  - homelab - k8s: workload integration - storage, security, networking
  - ai integration: ollama + stable diffusion + open-webui

After those, I should be primed for app development to create some $$
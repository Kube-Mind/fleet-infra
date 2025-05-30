# NOTES

## infra-management

Tools and applications that are used for managing the underlying baremental infrastructure used by kubernetes.
ArgoCD sync wave sequence are as follows:

1. ArgoCD synchronisation - ArgoCD to manage itself using configurations from gitops repository.
2. Tuned installation of the following applications:

    - cert-manager
    - external-secrets
    - k3s-upgrader
    - nfs-provisioner
    - nvidia-operator
    - longhorn

3. Tuned installation of the following applications dependent on longhorn - storage manager.

    - openbao

## infra-operations

Custom operations used for automating cluster management. Applications are indirectly dependent `infra-management` application states.
Involves asynchronous installation of the following applications:

- k3s-upgrader
- letsencrypt
- secrets-integrator

## infra-monitoring

Applications used for monitoring kubernetes infrastructure

- kube-prometheus-stack

## dev-management

Enabler applications that elevate developer experience.
Involves asynchronous installation of the following applications:

- gitlab-runner
- harbor
- actions-runner-controller (TBA)

## dev-operations

Custom solutions used for automating dev-management application operations.
The following solutions are to be added:

1. Automated secrets rotations:

    - gitlab runner
    - github actions runner
    - vault/openbao certificates renewal

## kmind-management

Inhouse management applications.

- dnsfix
- chartwatch

## work

ska
    ska-dependencies
    ska-dev-env
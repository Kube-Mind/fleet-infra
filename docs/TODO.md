# TODO

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
# ArgoCD

A kubernetes cluster can be bootstraped using ArgoCD make targets.

| target | description |
| ------ | ----------- |
| argocd-install | Installs ArgoCD using the provided values yaml |
| argocd-wait | Waits for successful ArgoCD installation |
| argocd-proxy | Creates a proxy tunnel for ArgoCD installation |
| argocd-password | Extracts ArgoCD from k3d cluster |
| argocd-login | ArgoCD authentication |
| argocd-bootstrap | Creates the main ArgoCD application which grabs all of the `fleet-infra` projects |
|||
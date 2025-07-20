# Simulating cluster environment

A localised Kubernetes cluster can be used for simulating deployment behaviours. `k3d` is used as the Kubernetes cluster simulator.

The following make targets are used for setting up a localised kubernetes cluster for deployment tests.

| target | description |
| ------ | ----------- |
| k3d-setup | Launches a k3d cluster |
| k3d-start | Starts a stopped k3d cluster |
| k3d-stop | Stops a running k3d cluster |
| k3d-teardown | Destroys a k3d cluster |
|||
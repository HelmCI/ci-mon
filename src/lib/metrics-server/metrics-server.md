# metrics-server

- [.. HOME](../../../README.md)
- [chart](../../../charts/metrics-server/README.md)
- [values template](metrics-server.tpl)
- <https://github.com/kubernetes-sigs/metrics-server/blob/master/README.md#requirements>
- <https://explore.ggcr.dev/?repo=registry.k8s.io/metrics-server/metrics-server>

```sh
kubectl get apiservices | grep metrics
kubectl delete apiservices.apiregistration.k8s.io v1beta1.metrics.k8s.io
kubectl get clusterrole | grep metrics
kubectl delete clusterrole system:metrics-server
kubectl get clusterrolebindings.rbac.authorization.k8s.io | grep metrics
kubectl delete clusterrolebindings.rbac.authorization.k8s.io system:metrics-server metrics-server:system:auth-delegator
kubectl get rolebindings.rbac.authorization.k8s.io -A | grep metrics
kubectl delete rolebindings.rbac.authorization.k8s.io -n kube-system metrics-server-auth-reader
helmwave up -t metrics-server

kubectl top node
kubectl top pod -A
```

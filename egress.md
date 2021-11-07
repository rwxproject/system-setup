# Egress

```yaml
istioctl install --set profile=demo --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
kubectl get istiooperator installed-state -n istio-system -o jsonpath='{.spec.meshConfig.outboundTrafficPolicy.mode}'
```

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: cnn
spec:
  hosts:
    - sys-vm-1
  ports:
    - number: 80
      name: http-port
      protocol: HTTP
    - number: 3000
      name: http-port-3000
      protocol: HTTP
    - number: 443
      name: https
      protocol: HTTPS
  resolution: DNS
```

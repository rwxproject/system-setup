# System Setup

## Ubuntu setup

vi /etc/netplan/00-installer-config.yaml

```yaml
network:
  ethernets:
    ens160:
      dhcp4: false
      addresses: [172.17.1.221/24]
      gateway4: 172.17.1.1
      nameservers:
        addresses: [172.17.1.1]
  version: 2
```

node01 172.17.1.221
node02 172.17.1.222
node03 172.17.1.223

## k3s install

First master node

curl -sfL https://get.k3s.io | K3S_TOKEN=SECRET sh -s - server --cluster-init --disable=traefik

Other master nodes

curl -sfL https://get.k3s.io | K3S_TOKEN=SECRET sh -s - server --server https://172.17.1.221:6443 --disable=traefik

## Cluster Setup

### Install istio

```shell
curl -sL https://istio.io/downloadIstioctl | sh -
export PATH=$PATH:$HOME/.istioctl/bin
istioctl install --set profile=demo
```

### Install istio addons

```shell
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/jaeger.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/kiali.yaml
```

### Install cert-manager

```shell
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
```

### Enable Istio injection

```shell
kubectl create ns auth-system
kubectl label namespace auth-system istio-injection=enabled --overwrite
kubectl get namespace -L istio-injection
```

helm repo add bitnami https://charts.bitnami.com/bitnami

### Install Keycloak

```shell
helm install keycloak bitnami/keycloak --set service.type=ClusterIP --set service.port=8080 --set service.httpsPort=8443 --namespace auth-system
# echo Username: user
# echo Password: $(kubectl get secret --namespace default keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
```

### Install opa

```shell
kubectl apply -f opa/
```

### Configure istio ingress

```shell
kubectl apply -f istio/
```

kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm

istioctl proxy-config route istio-ingressgateway-5abc45c5cb-44l47.istio-system -o json

---

kubectl apply -f system1/namespace.yaml  
kubectl create secret generic opa-policy --from-file system1/opa/policy.rego
kubectl apply -f system1/opa/opa.yaml

kubectl apply -f system1/http-app1
kubectl apply -f system1/http-app2
kubectl apply -f system1/istio/gateway.yaml
kubectl apply -f system1/istio/virtualservice.yaml

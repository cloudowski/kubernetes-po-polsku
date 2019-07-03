# Instalacja EKS

Użyj skryptu **create-eks.sh** i uzbrój się w cierpliwość - to potrwa 15 minut
lub dłużej.

Skonfiguruj odpowiednio dodatki do kubectl -
[https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html#eks-prereqs](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html#eks-prereqs).

# Konfiguracja

Odpal **configure.sh**, który zrobi za ciebie wszystko.

# Instalacja aplikacji

Wykorzystamy już napisane pliki do konfiguracji z odcinka o [Helm](../9-helm). 

## Gogs

```
. get-apps-dns-suffix.sh

helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

helm install incubator/gogs -n git -f ../9-helm/gogs/values.yaml --set service.ingress.hosts[0]=git.$APPS_DNS
```

## Dokuwiki 

```
. get-apps-dns-suffix.sh
helm install stable/dokuwiki -n wiki -f ../9-helm/dokuwiki/values.yaml --set ingress.hosts[0].name=wiki.$APPS_DNS
```


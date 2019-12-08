# Polecenia wykorzystywane w odcinku

* Dodanie repozytoriów Helma

```shell
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
 ```

* Instalacja gogs z Chart - Helm 2

```shell
helm install -n gogs2 -f gogs-values.yaml incubator/gogs
```

* Instalacja gogs z Chart - Helm 3

```shell
helm install gogs3 -f gogs-values.yaml incubator/gogs
```

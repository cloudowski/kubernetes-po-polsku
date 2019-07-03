# Instalacja bezpośrednio

Korzystając z definicji chart w [gitea/](gitea/)

```
helm install gitea/
```

# Instalacja własnego repozytorium (Chartmuseum)

Instalacja chartmuseum z własną konfiguracją

```
helm install stable/chartmuseum -f chartmuseum-values.yaml
```

Dodanie repozytorium do helma
```
helm repo add minikube http://charts.192.168.99.100.nip.io/
```

# Publikacja chart w repo

Instalacja pluginu helm-push

```
helm plugin install https://github.com/chartmuseum/helm-push
```

Publikacja charta

```
helm push --insecure gitea/ minikube
```

# Instalacja z własnego repo

Aktualizacja metadanych repozytorium

```
helm repo update
```

Instalacja z własną konfiguracją

* test

```
helm install minikube/gitea -f gitea1-values.yaml
```

* prod

```
helm install minikube/gitea -f gitea2-values.yaml
```



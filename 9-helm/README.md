# Instalacja Helm

Postępuj zgodnie z instrukcją na stronie
[https://github.com/helm/helm](https://github.com/helm/helm).

## Inicjalizacja

Instalacja komponentu **Tiller**

```
helm init
```

# Przykład 1 - dokuwiki

Instalacja **dokuwiki** z własną konfiguracją

```
helm install stable/dokuwiki -n wiki -f dokuwiki/values.yaml
```

Dostęp: [http://wiki.192.168.99.100.nip.io](http://wiki.192.168.99.100.nip.io)


# Przykład 2 - gogs git

Dodanie repozytorium testowego *(incubator)*

```
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
```

Instalacja **gogs** z własną konfiguracją

```
helm install incubator/gogs -n git -f gogs/values.yaml
```

Dostęp: [http://git.192.168.99.100.nip.io](http://git.192.168.99.100.nip.io)


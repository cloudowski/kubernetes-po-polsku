# Zasoby

* Link do Digital Ocean, dzięki któremu dostajesz **$50** na start -
  [https://cloudowski.com/digitalocean](https://cloudowski.com/digitalocean)
* Narzędzie K9S - [https://k9ss.io/](https://k9ss.io/)
* Narzędzie kubectx/kubens -
  [https://github.com/ahmetb/kubectx/](https://github.com/ahmetb/kubectx/)

# Polecenia wykorzystywane w odcinku

* Start minikube z innego profilu

```
minikube start -p cloudowski
```

* Podgląd konfiguracji tylko z bieżącego kontekstu

```
kubectl config view --minify
```

* Listowanie dostępnych kontekstów

```
kubectl config get-contexts
```

* Ustawienie domyślnego namespace dla bieżącego kontekstu

```
kubectl config set-context --current --namespace=kube-system
```


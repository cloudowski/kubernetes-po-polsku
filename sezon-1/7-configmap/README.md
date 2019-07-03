# ConfigMap

**Gitea** wystartuje na porcie **31080**. Może to być link jak ten:
[http://192.168.99.100:31080/](http://192.168.99.100:31080/) (adres IP twojego
minikube może być inny).


## Wymuszony deployment

Po zmianie konfiguracji możesz wymusić deployment poprzez zmianę w obiekcie
deployment np. przez nadanie labelki:

```
kubectl patch deployment gitea -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"

```

## Tworzenie mapy z pliku

```
kubectl create configmap gitea-config-file --from-file=app.ini
```

## Więcej opcji dla gitea

Opcje, których możesz użyć opisane są w
[dokumentacji](https://docs.gitea.io/en-us/install-with-docker/).

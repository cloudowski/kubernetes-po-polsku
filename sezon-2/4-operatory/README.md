# CRD i operatory

* Minikube

Potrzebujemy więcej pamięci dla operatorów

```
minikube start --memory=5000
```
* Instalacja kubedb

```
curl -fsSL https://raw.githubusercontent.com/kubedb/cli/0.12.0/hack/deploy/kubedb.sh | bash
```

* Instalacja przykładowej bazy - zasób obsługiwany przez operator Kubedb


Instalacja phpMyAdmin

```
kubectl create ns demo
kubectl create -f https://raw.githubusercontent.com/kubedb/cli/0.12.0/docs/examples/mysql/quickstart/demo-1.yaml
```

Link do phpMyAdmin

```
minikube service myadmin -n demo --url
```

* Instalacja przykładowej bazy

```
kubectl create -f https://raw.githubusercontent.com/kubedb/cli/0.12.0/docs/examples/mysql/quickstart/demo-2.yaml
```

* Instalacja bazy z własną definicją

```
kubectl apply -f mysqldb.yaml
```

* Instalacja aplikacji Ghost łączącej się do bazy

```
DBUSER=$(kubectl get secret mydb-auth -o jsonpath='{.data.username}'|base64 --decode)
DBPASS=$(kubectl get secret mydb-auth -o jsonpath='{.data.password}'|base64 --decode)

GHOST_HOST=ghost.$(minikube ip).nip.io

helm install stable/ghost --values=ghost-values.yaml --name=ghost-kubedb \
    --set externalDatabase.user="$DBUSER" \
    --set externalDatabase.password="$DBPASS" \
    --set ghostHost=$GHOST_HOST \
    --set ingress.hosts[0].name=$GHOST_HOST

echo http://$GHOST_HOST
```


* Inne przykłady aplikacji


[Prestashop](https://hub.helm.sh/charts/stable/prestashop)

```
PRESTA_HOST=presta.$(minikube ip).nip.io
helm install --name presta stable/prestashop \
  --set prestashopUsername=admin,prestashopPassword=admin,mariadb.enabled=false,externalDatabase.user="$DBUSER",externalDatabase.password="$DBPASS",externalDatabase.host=mydb,ingress.enabled=true,ingress.hosts[0].name=$PRESTA_HOST
echo http://$PRESTA_HOST
```

[Owncloud](https://hub.helm.sh/charts/stable/owncloud)

```
OCLOUD_HOST=owncloud.$(minikube ip).nip.io
helm install --name owncloud stable/owncloud \
  --set owncloudUsername=admin,owncloudPassword=admin,mariadb.enabled=false,owncloudHost=$OCLOUD_HOST,externalDatabase.user="$DBUSER",externalDatabase.password="$DBPASS",externalDatabase.host=mydb,ingress.enabled=true,ingress.hosts[0].name=$OCLOUD_HOST
echo http://$OCLOUD_HOST
```
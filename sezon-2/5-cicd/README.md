# Jenkins jako kontener

* Komendy

```
helm init

# poczekaj aż tiller będzie dostępny 

kubectl create ns jenkins

kubectl apply -f jenkins/casc/ -n jenkins

# poniższe zadziała tylko na linux/macos - windowsowi mają gorzej, no chyba, że mają WSL/WSL2
JENKINS_HOST=jenkins.$(minikube ip).nip.io

helm install --namespace jenkins -n jenkins stable/jenkins -f jenkins/jenkins-values.yaml \
    --set master.ingress.hostName=$JENKINS_HOST



# serviceaccount i spięcie z rolą "cluster-admin"

kubectl create sa deployer -n jenkins
kubectl create clusterrolebinding jenkins-deployer-admin --clusterrole=cluster-admin --serviceaccount=jenkins:deployer


# podmień na ścieżkę do twojej konfiguracji dockera
kubectl create secret generic jenkins-docker-creds  --from-file=.dockerconfigjson=/Users/tomasz/.docker/config.json  --type=kubernetes.io/dockerconfigjson -n jenkins

echo http://$JENKINS_HOST
```

# Gitea 


```
CHARTDIR=/tmp/gitea-helm-chart

git clone https://github.com/jfelten/gitea-helm-chart $CHARTDIR


DNSDOMAIN="$(minikube ip).nip.io"

# poprawka nieprawidłowej ścieżki dla sqlite3
sed -i "" -e 's|= data/gitea.db|= /data/gitea.db|' $CHARTDIR/templates/gitea/gitea-config.yaml

helm install --values gitea-values.yaml --name gitea \
    --set service.http.externalHost=gitea.${DNSDOMAIN} \
    $CHARTDIR

echo http://gitea.${DNSDOMAIN}

# poniższe dopiero jak już Gitea będzie dostępna
GITEA_POD=$(kubectl get pod -lapp=gitea-gitea --no-headers|awk '{print $1}')
kubectl exec -ti $GITEA_POD -- su git -c '/app/gitea/gitea admin create-user --username root --password root --email root@example.com --admin'

```

# Zasoby

* Instalacja minishift - [https://docs.okd.io/latest/minishift/getting-started/installing.html](https://docs.okd.io/latest/minishift/getting-started/installing.html)
* Strona GitHuba z wydaniami minishift do ściągnięcia - [https://github.com/minishift/minishift/releases](https://github.com/minishift/minishift/releases)
* Strona GitHuba z wydaniami oc do ściągnięcia - [https://github.com/openshift/origin/releases/tag/v3.11.0](https://github.com/openshift/origin/releases/tag/v3.11.0)

# Polecenia wykorzystywane w odcinku

* Przelogowanie na admina (po uprzednim zalogowaniu na developera)

```
oc login -u system:admin
```

* Dodanie uprawnień do uruchamiania kontenerów na dowolnych uidach (również root)

```
oc adm policy add-scc-to-user anyuid -z default
```

* Nadanie użytkownikowi developer roli cluster-admin

```
oc adm policy add-cluster-role-to-user cluster-admin developer
```

* Deploy przez gu + oc new-app

```
oc new-app --docker-image=nginx:latest --name=mynginx
```

* Dodanie zwykłej trasy (route) w trybie http

```
oc expose svc mynginx
```

* To samo co wyżej, ale z opcją szyfrowania (https)
 
```
oc create route edge mynginxtls --service=mynginx
```
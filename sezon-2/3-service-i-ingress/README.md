# Zasoby

* Link do Digital Ocean, dzięki któremu dostajesz **$50** na start -
  [https://cloudowski.com/digitalocean](https://cloudowski.com/digitalocean)
* Instalacja Nginx Ingress Controller na Digital Ocean -
  [https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm)
* Instalacja Helm na Digital Ocean
  [https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager](https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager)

# Polecenia wykorzystywane w odcinku

* Start minikube z innego profilu

```
minikube start -p cloudowski
```

minikube addons enable ingress

kubectl run ghost --image=ghost

kubectl expose deployment ghost --type=NodePort --target-port=2368 --port=80 --name=g1
kubectl expose deployment ghost --type=LoadBalancer --target-port=2368 --port=80 --name=g2

kubectl run --rm -ti alpine --generator=run-pod/v1 --image=alpine
apk add --no-cache bind-tools


kubectl expose deployment ghost --cluster-ip=None --target-port=2368 --port=80 --name=g3

helm install stable/ghost --values=ghost-values.yaml --name=g1

# DO

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
helm install stable/nginx-ingress --name nginx-ingress --set controller.publishService.enabled=true

kubectl create ns g1
kubens g1
helm install stable/ghost --values=ghost-values-do.yaml --name=g1

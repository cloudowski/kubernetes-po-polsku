# Przydatne komendy

* Aktualizacja deploymentu z użyciem cli i zapisaniem komendy

```
kubectl set image deploy/fussy fussy=cloudowski/fussy-container:0.4 --record
```

* Status deploymentu

```
kubectl rollout status deploy/fussy
```

* Historia deploymentu

```
kubectl rollout history deploy/fussy
```

# Vault na Kubernetes

Znajdziesz tutaj komendy do uruchomienia Vault. 

## 1. Instalacja Vault z Helm Chart

```shell
CHARTDIR=/tmp/vault-helm

git clone https://github.com/hashicorp/vault-helm $CHARTDIR

DNSDOMAIN="$(minikube ip).nip.io"

helm install vault -f vault-values.yaml \
    --set server.ingress.hosts[0].host=vault.${DNSDOMAIN} \
    $CHARTDIR

echo http://vault.${DNSDOMAIN}


cat << EOF
##################

# Komenda do zalogowania na poda z vaultem

kubectl exec -ti vault-0 sh

# Inicjalizacja

vault operator init

# NIE ZAPOMNIJ zapisać informacji które powyższa komenda zwróci! 

# Użyj 3 tokenów do "odpieczętowania" vaulta komendą

vault operator unseal

# Eksport zmiennych na twoim kliencie

export VAULT_ADDR=http://vault.${DNSDOMAIN}
export VAULT_TOKEN=<ROOT_TOKEN_GENERATED_DURING_INIT>

EOF
```

## 2. Konfiguracja Vaulta

*Oparte głównie na wpisie z oficjalnego bloga https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar*


```shell
## Część Kubernetesowa - wykonaj z poda vaulta

## Potrzebujesz też tokenu root:
## export VAULT_TOKEN=<ROOT_TOKEN>

cat <<EOF > /home/vault/app-policy.hcl
path "secret*" {
  capabilities = ["read"]
}
EOF

vault policy write app /home/vault/app-policy.hcl

vault auth enable kubernetes

vault write auth/kubernetes/config \
   token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
   kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
   kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt


# allow access from all namespaces with 'app' sa only
vault write auth/kubernetes/role/myapp \
   bound_service_account_names=app \
   bound_service_account_namespaces='*' \
   policies=app \
   ttl=1h

# not enabled by default?
vault secrets enable -path=secret kv

# create secret

vault kv put secret/helloworld username=hellovault password=P@ssw0rd123
```

## 3. Instalacja aplikacji

```shell
kubectl apply -f krazy-cow.yaml
```

Weryfikacja - nie powinno być żadnych danych w `/vault/secrets`:

```shell
kubectl iexec krazy-cow -- ls -l /vault/secrets
```

Dodanie anotacji agenta vaulta do aplikacji:

```shell
kubectl patch deployment krazy-cow --patch "$(cat krazy-cow-patch.yaml)"
```

Ponowna weryfikacja

```shell
kubectl iexec krazy-cow -- ls -l /vault/secrets
kubectl iexec krazy-cow -- cat /vault/secrets/helloworld
```

Zmiana szablonu dla wynikowego pliku:

```shell
kubectl patch deployment krazy-cow --patch "$(cat krazy-cow-patch2.yaml)"
```

## 4. Vault i dynamiczne poświadczenia (credentials) do bazy danych

Instalacja bazy

```shell
helm install mydb \
  --set postgresqlPassword=secretpassword,postgresqlDatabase=mydatabase \
  --set service.type=NodePort,service.nodePort=32543 \
    stable/postgresql
```

Włączenie silnika obsługi baz danych na vault

```shell
vault secrets enable database
```


Konfiguracja połączenia do bazy z vaulta

```shell
vault write database/config/postgresql \
        plugin_name=postgresql-database-plugin \
        allowed_roles=readonly \
        connection_url=postgresql://postgres:secretpassword@$(minikube ip):32543/postgres?sslmode=disable
```

Utworzenie szablonu roli, którą będzie tworzył vault na bazie danych

```shell
cat << EOF > /tmp/vault-postgres.sql
CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
EOF

vault write database/roles/readonly db_name=postgresql \
        creation_statements=@/tmp/vault-postgres.sql \
        default_ttl=30s max_ttl=60s
```

Utworzenie polityki zezwalającej na pobieranie danych logowania do bazy

```shell
cat << EOF > /tmp/postgres-policy.hcl
path "database/creds/readonly" {
  capabilities = [ "read" ]
}
EOF

vault policy write dbapps /tmp/postgres-policy.hcl


vault write auth/kubernetes/role/myapp \
   bound_service_account_names=app \
   bound_service_account_namespaces='*' \
   policies=app,dbapps \
   ttl=1h
```

### Weryfikacja

Pobranie tokena

```shell
APP_TOKEN=$(vault token create -policy="dbapps" -field=token)
VAULT_TOKEN="$APP_TOKEN" vault read database/creds/readonly
```

Uruchomienie testowego kontenera z postgresql

```shell
kubectl run -i --tty --rm debug --image=postgres:alpine --restart=Never -- sh
```

Dodanie aplikacji z konfiguracją

```shell
kubectl apply -f krazy-cow.yaml
kubectl patch deployment krazy-cow --patch "$(cat krazy-cow-patch3.yaml)"
```

Dane do logowania powinny być w `/vault/secrets` wewnątrz poda.
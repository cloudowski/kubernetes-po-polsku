#!/usr/bin/env bash

ELB=$(kubectl get svc ingress-nginx -o jsonpath="{ .status['loadBalancer']['ingress'][0]['hostname'] }" -n ingress-nginx)

export APPS_DNS="$(host $ELB| sed -e 's/.*has address \(.*\)/\1/'|head -n1).nip.io"
echo APPS_DNS="$APPS_DNS"

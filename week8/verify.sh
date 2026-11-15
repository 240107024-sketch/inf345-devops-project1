#!/usr/bin/env bash
set -euo pipefail

kubectl config use-context kind-inf345
kubectl wait node --all --for=condition=Ready --timeout=120s
namespace=week8-lab
kubectl create namespace "$namespace"
trap 'kubectl delete namespace "$namespace" --wait=false' EXIT
k() { kubectl -n "$namespace" "$@"; }
cd "$(dirname "$0")"

k run web --image=nginx:1.30.5-alpine --restart=Never
k wait pod/web --for=condition=Ready --timeout=120s
k delete pod web
test -z "$(k get pods -o name)"

apply_stable() {
  sed -e "s/replicas: 3/replicas: $1/" -e 's/nginx:1.31.6-alpine/nginx:1.30.5-alpine/' \
    playground/web-deployment.yaml | k apply -f -
  k rollout status deployment/web --timeout=120s
  test "$(k get deployment web -o jsonpath='{.status.readyReplicas}')" = "$1"
}
apply_stable 3
pod="$(k get pods -l app=web -o jsonpath='{.items[0].metadata.name}')"
k delete pod "$pod"
k rollout status deployment/web --timeout=120s
k get pods
apply_stable 5
k scale deployment/web --replicas=2
k rollout status deployment/web --timeout=120s
apply_stable 5
apply_stable 3

k apply -f playground/web-service.yaml
k get endpointslices -l kubernetes.io/service-name=web
web_headers() {
  k run "curl-$1" --rm -i --restart=Never --image=curlimages/curl:8.22.0 -- \
    curl -fsSI --max-time 8 --retry 3 --retry-all-errors http://web
}
web_headers original | tee /dev/stderr | grep -i 'Server: nginx/1.30.5'
k patch service web --type=merge -p '{"spec":{"selector":{"app":"wev"}}}'
k get endpointslices -l kubernetes.io/service-name=web
if web_headers broken-selector; then
  echo 'Expected the incorrect selector to stop traffic'
  exit 1
fi
k apply -f playground/web-service.yaml

k apply -f playground/web-deployment.yaml
k rollout status deployment/web --timeout=120s
web_headers upgraded | tee /dev/stderr | grep -i 'Server: nginx/1.31.6'
k set image deployment/web web=nginx:1.31.66-alpine
if k rollout status deployment/web --timeout=25s; then
  echo 'Expected the invalid image rollout to fail'
  exit 1
fi
k get pods
k get events --sort-by=.lastTimestamp
web_headers during-failure | tee /dev/stderr | grep -i 'Server: nginx/1.31.6'
k rollout undo deployment/web
k rollout status deployment/web --timeout=120s
k rollout history deployment/web

k apply -f playground/mine.yaml
k rollout status deployment/mine --timeout=180s
k get --raw "/api/v1/namespaces/$namespace/services/mine:80/proxy/healthz" | tee /dev/stderr | grep -Fx OK

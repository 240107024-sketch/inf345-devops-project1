#!/usr/bin/env bash
set -euo pipefail

kubectl -n drill set image deployment/drill app=ghcr.io/inf345/notes-rescue:84921690055cf871e6cfd1c57885a754b4172897
kubectl -n drill rollout status deployment/drill --timeout=180s
kubectl -n drill get pods,endpointslices

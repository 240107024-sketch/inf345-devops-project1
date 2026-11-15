# Week 9 incident drill

Scenario 1 was selected for practice. The failing request and Kubernetes events are in the [diagnostic run](https://github.com/240107024-sketch/inf345-devops-project1/actions/runs/43738686417/job/132886855185#step:4:1).

1. **Impact** — requests to the drill Service on port 80 failed to connect because neither application pod was ready.
2. **Detection** — kubectl -n drill get events --sort-by=.lastTimestamp reported ghcr.io/inf345/notes-rescue:8492169: not found. Both pods showed ErrImagePull.
3. **Root cause** — the Deployment specified a seven-character image tag, while the registry published the full commit SHA as the tag.
4. **Fix** — update the Deployment's app container to ghcr.io/inf345/notes-rescue:84921690055cf871e6cfd1c57885a754b4172897, wait for rollout, and rerun the user-facing check.
5. **Prevention** — verify the exact registry tag exists in CI and fail the deployment check unless the Service answers ok after rollout.

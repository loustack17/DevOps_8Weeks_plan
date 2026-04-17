# go-api — DevOps Learning Portfolio

A structured, self-directed learning portfolio covering the full DevOps/SRE stack on GCP.
The Go API is intentionally minimal — it exists as a concrete target to practice real infrastructure and deployment patterns around.

## Learning Approach

> See the result first → understand why → connect to system design trade-offs

Each phase is hands-on before theory. The goal is not to memorise tooling, but to understand *why* each design decision exists and what the trade-offs are.

Blogs documenting each phase: [LouStackBase](https://loustack17.github.io/)

---

## Progress

| Phase | Topic | Core SD Concept | Status |
|---|---|---|---|
| 1 | Docker + Kubernetes Core | — | ✅ Done |
| 2 | K8s Failure Modeling | — | ✅ Done |
| 3 | K8s Review Checkpoint | — | ✅ Done |
| 4 | Networking + GCP Fundamentals | Scalability | ✅ Done |
| 5 | IaC + Least Privilege (Terraform + Ansible) | CAP Theorem | ✅ Done |
| 6 | CI/CD + GitOps (GitHub Actions + ArgoCD) | Reliable Delivery | 🔄 In Progress |
| 7 | Monitoring + Observability (GKE + Prometheus + Grafana) | Observability | ⏳ Planned |
| 8 | Advanced SD + Interview Prep | Overload Protection | ⏳ Planned |
| 9 | Best Practices Case Studies | — | ⏳ Planned |

---

## Phase Highlights

### Phase 1 — Docker + Kubernetes Core
- Multi-stage Docker build to `scratch` and `distroless` base images
- K8s control plane vs worker node architecture; reconciliation loop
- Deployment → ReplicaSet → Pod, rolling update with `maxSurge` / `maxUnavailable`
- Service DNS-based discovery, HPA with metrics-server
- `kubectl` debug flow: `get pods → describe → logs → events`

### Phase 2 — K8s Failure Modeling
- OOMKilled (exit code 137), CrashLoopBackOff exponential backoff, ImagePullBackOff
- Readiness probe failure vs Liveness probe failure — different outcomes
- ResourceQuota enforcement at the API server layer
- ConfigMap vs Secret injection: `envFrom` (whole map) vs `valueFrom` (single key)
- Cross-namespace DNS: `service.namespace.svc.cluster.local`

### Phase 4 — Networking + GCP Fundamentals
- DNS resolution flow, TLS handshake, L4 vs L7 load balancer trade-offs
- Reverse proxy pattern: every LB is a reverse proxy, not every reverse proxy does LB
- GCP VPC (global) vs Azure VNet (regional) — key architectural difference
- Service Account vs Azure Managed Identity — explicit identity vs credentials-free by design
- GCP hands-on: VPC, Subnet, Firewall Rules, Service Account via Console and gcloud

### Phase 5 — IaC + Least Privilege
- Terraform module pattern: define once, pass different variables per environment
- GCS remote state with native locking — CAP Theorem applied: two concurrent `apply` calls cannot both write state
- `terraform state mv / rm / import` for refactoring without destroying resources
- Workload Identity Federation: GitHub Actions → GCP OIDC, no Service Account key ever stored
- `attribute_mapping` (JWT claim → GCP attribute) and `attribute_condition` (repo-scoped access)
- Ansible: idempotency in practice — `file` and `copy` modules show `ok` on second run, `command` module always runs

### Phase 6 — CI/CD + GitOps *(in progress)*
**Completed:**
- GitHub Actions pipeline: `test → build → deploy` with job-level `needs` gates
- Keyless GCP auth via WIF — `id-token: write` permission scoped to deploy job only
- Docker image pushed to Artifact Registry on every merge to main
- Terraform bootstrap layer separates one-time GCP setup from environment resources

**In progress:**
- ArgoCD on k3s — pull-based GitOps, monitoring `k8s/` directory for changes
- Push-based vs Pull-based deployment: CI tool needs K8s credentials (push) vs ArgoCD polls git (pull)

---

## Repository Structure

```
.
├── cmd/server/         # application entrypoint
├── internal/           # business logic
├── server/             # HTTP handlers
├── k8s/                # Kubernetes manifests
│   ├── deployment.yaml # rolling update, resource limits
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   └── hpa.yaml
├── terraform/
│   ├── bootstrap/      # one-time GCP setup: WIF, Artifact Registry, SA, IAM
│   ├── environments/   # environment-specific resources
│   └── modules/        # reusable modules (vpc)
├── .github/workflows/
│   └── ci.yml          # CI: test → build → deploy
├── Dockerfile          # multi-stage build to scratch
└── Dockerfile.distroless
```

---

## Tech Stack

| Layer | Tech |
|---|---|
| Language | Go |
| Container | Docker (multi-stage, scratch base) |
| Registry | GCP Artifact Registry |
| IaC | Terraform / OpenTofu |
| CI/CD | GitHub Actions |
| Auth | Workload Identity Federation (OIDC, keyless) |
| Orchestration | Kubernetes (k3s locally, GKE planned) |
| Cloud | GCP |
| Planned | ArgoCD, Prometheus, Grafana |

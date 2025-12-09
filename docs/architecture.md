# Architecture Overview

## Environments
- **dev**: single node group, lower resource limits, permissive ingress; fast iteration and feature flags on.
- **staging**: mirrors prod topology (HA control plane, at least two node groups), blue/green or canary enabled; synthetic load for validation.
- **prod**: multi-AZ EKS with IRSA, private nodes, L7 ingress with ACM certificates, autoscaling, and PodDisruptionBudgets.

## Infrastructure (Terraform)
- **network module**: VPC, public + private subnets, NAT gateway, security groups, Route53 zone (optional).
- **eks module**: EKS cluster, managed node groups for `system` (ArgoCD/ingress) and `workload` (boutique services), autoscaling, IRSA, cluster autoscaler.
- **iam module**: IAM roles for Jenkins (if using AWS build infra), ArgoCD repo server IRSA, External Secrets operator; least-privilege policies.
- **addons** (optional): ArgoCD install via Helm provider, External Secrets operator, Gatekeeper.

## Application layer
- **Microservices**: Google Online Boutique (frontend, productcatalog, cart, checkout, payment, shipping, currency, recommendation, email).
- **Packaging**: Helm umbrella chart in `k8s/helm/online-boutique` with per-service Deployments, Services, HPAs, PodDisruptionBudgets, and PodMonitor templates.
- **Config & secrets**: values files per environment; secrets sourced via External Secrets from AWS Secrets Manager.
- **Ingress**: NGINX or AWS ALB ingress controller with TLS via ACM; optional AWS WAF.

## GitOps (ArgoCD)
- **App-of-apps bootstrap**: installs ArgoCD into `argocd` namespace and registers this repo.
- **ApplicationSet**: parameterized deployment of the online boutique chart across `dev`, `staging`, `prod` using a list generator to set namespaces and value files.
- **Policy**: SSO + RBAC; optional Sync Waves and health checks to order infra vs apps.

## CI/CD
- **CI (Jenkins)**: builds and scans images, runs unit/integration tests, pushes to Docker Hub (`namdeopawar/*`), bumps image tags in Helm values, and opens PRs against this repo.
- **CD (ArgoCD)**: watches the repo and syncs after PR merge; progressive delivery via `rolloutStrategy` values (canary/blue-green with Argo Rollouts if desired).
- **Quality gates**: SAST/Trivy scan, `kubectl conftest` with OPA policies, optional `kube-score`/`polaris`.

## Observability
- **Logging**: ship to CloudWatch Logs (or Loki) via FluentBit daemonset.
- **Metrics**: Prometheus Operator stack with PodMonitor and ServiceMonitor; dashboards for latency/error rate/saturation.
- **Tracing**: OpenTelemetry collector exporting to X-Ray/Jaeger.

## Security
- **Network**: private nodes, limited egress via NAT, NetworkPolicies to isolate services.
- **Identity**: IRSA for AWS API access; dedicated service accounts per service.
- **Secrets**: External Secrets + KMS-encrypted secrets in AWS Secrets Manager; no secrets in repo.
- **Supply chain**: image signing (cosign) and verification policy (Kyverno/Gatekeeper).

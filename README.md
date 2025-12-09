# Aurora Boutique Platform (AWS EKS + GitOps)

Reference implementation to showcase DevOps skills: run the Google Online Boutique microservices on AWS EKS with IaC (Terraform), CI (Jenkins), CD (ArgoCD/GitOps), Docker Hub registry, and multi-env overlays. Intended for a portfolio/résumé entry and a public GitHub repo (e.g., `github.com/namdeopawar/aurora-boutique-platform`).

## What you get
- 8–10 microservices from Google Online Boutique, deployed via Helm with per-environment overlays (dev/staging/prod) on AWS EKS.
- ArgoCD ApplicationSet for GitOps deployments; app-of-apps bootstrap for clusters.
- Terraform to provision VPC + EKS + node groups + IAM for workloads.
- Jenkins pipeline that builds & scans images, pushes to Docker Hub (`hub.docker.com/r/namdeopawar`), updates GitOps manifests, and triggers ArgoCD sync.
- Opinionated repo layout ready to demo publicly (GitHub + Docker Hub).

## Repo layout
- `services/` — references/notes for pulling the Google Online Boutique codebase (kept out-of-tree to stay lightweight).
- `infra/terraform/` — reusable modules (`network`, `eks`, `iam`) and env roots (`dev`, `staging`, `prod`).
- `k8s/helm/online-boutique/` — umbrella chart values and helper templates for the microservices.
- `k8s/overlays/` — Kustomize-style env values for dev/staging/prod (secrets via External Secrets or AWS Secrets Manager).
- `argo/` — ArgoCD app-of-apps bootstrap plus ApplicationSet for the boutique chart.
- `ci/` — Jenkinsfile and helper scripts for CI→GitOps (image build/push, chart value bump, PR).
- `docs/` — architecture and operations notes.

## Running the stack (high level)
1) **Provision infra**: `cd infra/terraform/environments/dev && terraform init && terraform apply` to create AWS VPC + EKS and IAM roles.
2) **Bootstrap GitOps**: `kubectl apply -f argo/bootstrap/argo-project.yaml -f argo/bootstrap/root-app.yaml` to install ArgoCD and register this repo.
3) **Deploy services**: ArgoCD syncs the ApplicationSet in `argo/applicationsets/online-boutique.yaml`, installing the Helm release per environment.
4) **Ship via CI**: Jenkins runs `ci/Jenkinsfile` to build, test, and push images to Docker Hub (`namdeopawar`), bump the Helm values (`k8s/helm/online-boutique/values-*.yaml`), and open a PR that ArgoCD will apply after merge.

## Resume-ready bullets
- Built multi-env Kubernetes platform (AWS EKS) with Terraform modules; automated VPC, node groups, and IRSA.
- Implemented GitOps with ArgoCD ApplicationSets and Helm for the Google Online Boutique microservices.
- Authored Jenkins CI that builds/scans images, pushes to Docker Hub (`namdeopawar/*`), updates GitOps manifests, and triggers progressive delivery across dev/staging/prod.
- Standardized secrets with External Secrets (AWS Secrets Manager) and policy-as-code guardrails (OPA/Gatekeeper) baked into the pipeline.

## Next steps
- Add the Google Online Boutique code as a submodule: `git submodule add https://github.com/GoogleCloudPlatform/microservices-demo services/online-boutique`.
- Point registry credentials and domain/DNS in `infra/terraform/environments/*/terraform.tfvars` and `k8s/overlays/*/values.yaml`.
- Update repo URLs in ArgoCD manifests to your GitHub (`https://github.com/namdeopawar/aurora-boutique-platform.git`).

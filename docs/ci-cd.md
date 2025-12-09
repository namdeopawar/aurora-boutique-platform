# CI/CD Flow

## CI (Jenkins)
1. Checkout repo and submodule for Google Online Boutique.
2. Run unit/integration tests per service (Go by default).
3. Build and scan images with Trivy, push to registry.
4. Update Helm values with new image tags across dev/staging/prod.
5. Open PR with manifest bumps; merge triggers ArgoCD sync.

## CD (ArgoCD)
- App-of-apps (`argo/bootstrap/root-app.yaml`) registers ApplicationSets.
- `argo/applicationsets/online-boutique.yaml` deploys Helm release to each environment.
- Sync policy is automated + self-heal; enable manual sync for prod if desired.

## Progressive delivery options
- Swap Deployments with Argo Rollouts in the chart and add canary steps per env.
- Gate promotions using Jenkins pipeline conditions and manual approvals for prod.

# Jenkins setup quickstart

1) **Credentials**
- `dockerhub-creds` (Username with Docker Hub personal access token) for pushes to `docker.io/namdeopawar/*`.
- `aws-creds` (Access key) if Jenkins builds on AWS; otherwise mount IAM role on the agent.
- `kubeconfig` or in-cluster service account for `kubectl/argocd` commands.
- `argocd-token` (optional) if you prefer CLI login; otherwise use in-cluster service account.

2) **Pipeline library**
- Job type: Multibranch or Git SCM pointing to `git@github.com:namdeopawar/aurora-boutique-platform.git`.
- Default branch: `main`.

3) **Agent image suggestions**
- Docker-enabled agent with `docker`, `kubectl`, `awscli`, `trivy`, `yq`, `helm`, `argocd` CLIs.

4) **Env overrides**
- REGISTRY already set to Docker Hub in Jenkinsfile; adjust only if you need a different namespace.
- SERVICES list covers all boutique microservices.

5) **Promotion**
- Make prod sync manual by removing `automated` from `argo/applicationsets/online-boutique.yaml` or adding `syncPolicy: {}`
- Gate prod in Jenkins with an input step after staging deploy, or branch protection for PR merges.

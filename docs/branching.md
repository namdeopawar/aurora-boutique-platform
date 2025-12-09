# Branching & Promotion Strategy (practical)

Recommended approach is trunk-based with short-lived feature branches and explicit release tags for promotions:

- **main**: always deployable; protected branch with required reviews + checks. Dev environment auto-follows `main`.
- **feature/\***: short-lived branches for work; merge via PR into `main`.
- **release tags**: cut a tag (e.g., `v0.9.0-aurora.1`) after staging signoff; ArgoCD for staging/prod tracks that tag.
- **hotfix/\***: branch from the tagged release, cherry-pick or merge back to `main`, retag (e.g., `v0.9.0-aurora.2`).

Environment mapping:
- **dev**: ArgoCD watches `main` (fast feedback).
- **staging**: ArgoCD watches latest release tag (`v*`); Jenkins can auto-tag after CI.
- **prod**: ArgoCD watches a specific tag you promote (manual approval), or a `prod` branch that only gets fast-forwarded from tags.

Jenkins pipeline tweaks (if you want automated tagging):
1. On successful staging deploy, create a release tag: `git tag v0.9.0-aurora.N && git push origin --tags`.
2. Bump `argo/applicationsets/online-boutique.yaml` to set `targetRevision: v*` for staging/prod, or use two ApplicationSets: one for `main` (dev) and one for `v*` (staging/prod).
3. Require a manual input step before pushing the prod tag.

PR hygiene:
- Enable branch protection on `main` (status checks + reviews).
- Disallow direct pushes to `main` and `prod` promotion branch (if you use one).
- Enforce conventional commits or semantic PR titles for clean changelogs.

Option B (GitFlow) is heavier; trunk-based + tags keeps CD simple and is commonly used in cloud-native teams.

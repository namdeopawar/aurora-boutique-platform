The Google Online Boutique code is not vendored to keep this repo small. Add it as a submodule when you want to build images:

```bash
git submodule add https://github.com/GoogleCloudPlatform/microservices-demo services/online-boutique
git -C services/online-boutique checkout v0.8.0
```

Jenkinsfile expects source under `services/online-boutique/src/<service>`.

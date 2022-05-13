# Cluster
Cluster Repository for GitOps Deploy of Infrastructure 

## Bootstrap
- Execute [bootstrap.sh](bootstrap/bootstrap.sh) to install or update argocd
- After initial Bootstrap app-of-apps will be synced by argocd as well [![App Status](https://argocd.robert-wiesner.de/api/badge?name=app-of-apps&revision=true)](https://argocd.robert-wiesner.de/applications/app-of-apps)
- argo-cd will also manage itself after bootstrap [![App Status](https://argocd.robert-wiesner.de/api/badge?name=argo-cd&revision=true)](https://argocd.robert-wiesner.de/applications/argo-cd)

## Projects [![App Status](https://argocd.robert-wiesner.de/api/badge?name=projects&revision=true)](https://argocd.robert-wiesner.de/applications/projects)
- [See /projects](./projects)
- Creating ArgoCD Projects for Grouping, see [Settings -> Projects](https://argocd.robert-wiesner.de/settings/projects)

## Apps [![App Status](https://argocd.robert-wiesner.de/api/badge?name=apps&revision=true)](https://argocd.robert-wiesner.de/applications/apps)
- [See /apps](./apps)
- Creating high level apps per project
 
### Infrastructure App [![App Status](https://argocd.robert-wiesner.de/api/badge?name=infrastructure&revision=true)](https://argocd.robert-wiesner.de/applications/infrastructure)
- [See /infrastructure](./infrastructure)
- Infrastructure deployments that don't belong to a specific namespace or other service (e.g. like argo-cd itself)
- sonarqube [![App Status](https://argocd.robert-wiesner.de/api/badge?name=sonar&revision=true)](https://argocd.robert-wiesner.de/applications/sonar)

### Services App [![App Status](https://argocd.robert-wiesner.de/api/badge?name=services&revision=true)](https://argocd.robert-wiesner.de/applications/services)
- [See /services](./services)
- ocpi-service-app-canary [![App Status](https://argocd.robert-wiesner.de/api/badge?name=ocpi-service-app-canary&revision=true)](https://argocd.robert-wiesner.de/applications/ocpi-service-app-canary)
- ocpi-service-ingress-canary [![App Status](https://argocd.robert-wiesner.de/api/badge?name=ocpi-service-ingress-canary&revision=true)](https://argocd.robert-wiesner.de/applications/ocpi-service-ingress-canary)


### RabbitMQ App [![App Status](https://argocd.robert-wiesner.de/api/badge?name=rabbitmq-app&revision=true)](https://argocd.robert-wiesner.de/applications/rabbitmq-app)
- [See /rabbitmq](./rabbitmq)
- Deploying rabbitmq-cluster-operator + rabbitmq-cluster
- rabbitmq-cluster-operator [![App Status](https://argocd.robert-wiesner.de/api/badge?name=rabbitmq-cluster-operator&revision=true)](https://argocd.robert-wiesner.de/applications/rabbitmq-cluster-operator)
- rabbitmq-cluster-canary [![App Status](https://argocd.robert-wiesner.de/api/badge?name=rabbitmq-cluster-canary&revision=true)](https://argocd.robert-wiesner.de/applications/rabbitmq-cluster-canary)


## Additional Config
- For helm based deployments (that are in a helm chart repository like sonar, rabbitmq-operator), the configuration is part of the application:
  - and can be added inline:
  ```yaml
      helm:
        values: |
          some-chart-prop: true
  ```
  - or by references value-xxx.yaml files:
  ```yaml
      helm:
        valueFiles:
        - values-xxx.yaml
  ```

- By default, application name = helm release name, this can be overridden as follows using `releaseName`:
  ```yaml
  metadata:
    name: app-name
      chart: chart-name
      helm:
        releaseName: release-name
  ```
## Upgrade
- argo-cd can be upgraded by changing the [helm chart](https://artifacthub.io/packages/helm/argo/argo-cd) versions in [Chart.yml](./bootstrap/argo-cd/Chart.yaml)
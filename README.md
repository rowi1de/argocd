# Cluster
- Cluster Repository for GitOps Deploy of Infrastructure
- It will deploy:
  - [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) 
  - [Traefik](https://doc.traefik.io/traefik/) 
  - [Traefik SSO for Google](https://github.com/thomseddon/traefik-forward-auth) 
  - [Cert Manager](https://cert-manager.io/docs/) 
  - [Bitnami sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) 

# Initial Setup
- Install [direnv](https://direnv.net/) if you don't have

## Google GKE Cluster (WIP!)
- Using a private cluster on Google Cloud GKE
- Code taken from [Neutrollized/free-tier-gke](https://github.com/Neutrollized/free-tier-gke) for almost free cluster
- `cd gke && direnv allow` will create a project in GKE

## Terraform (WIP!)
- Check [terraform.tfvars](./gke/terraform/terraform.tfvars) for default
- `cd terraform  && direnv allow` will create cluster


## Bootstrap GitOps Cluster
- Execute [bootstrap.sh](bootstrap/bootstrap.sh) to install ArgoCD
- After initial Bootstrap app-of-apps will be synced by ArgoCD as well [![App Status](https://argocd.robert-wiesner.de/api/badge?name=app-of-apps&revision=true)](https://argocd.robert-wiesner.de/applications/app-of-apps)
- ArgoCD will also manage itself after bootstrap [![App Status](https://argocd.robert-wiesner.de/api/badge?name=argocd&revision=true)](https://argocd.robert-wiesner.de/applications/argocd)
- Note: 
  - Please update ArgoCD admin password or disable the user
  - Traefik Dashboard has "admin/admin" by default:
  ```shell 
   echo $(htpasswd -n admin) | kubectl create secret generic traefik-basic-auth -n traefik --dry-run=client \
   --from-file=users=/dev/stdin -o yaml \
   | kubeseal --controller-namespace infrastructure --controller-name sealed-secrets -o yaml \
   >! infrastructure/ingress/traefik-basic-auth-sealed.yaml 
  ```
## ArgoCD

| **App**        | **Status** |
|----------------|------------|
| app-of-apps    |[![App Status](https://argocd.robert-wiesner.de/api/badge?name=app-of-apps&revision=true)](https://argocd.robert-wiesner.de/applications/app-of-apps)           |
| argocd         | [![App Status](https://argocd.robert-wiesner.de/api/badge?name=argocd&revision=true)](https://argocd.robert-wiesner.de/applications/argocd)     |
| projects       | [![App Status](https://argocd.robert-wiesner.de/api/badge?name=projects&revision=true)](https://argocd.robert-wiesner.de/applications/projects)     |
| apps           |     [![App Status](https://argocd.robert-wiesner.de/api/badge?name=apps&revision=true)](https://argocd.robert-wiesner.de/applications/apps)       |
| infrastructure |    [![App Status](https://argocd.robert-wiesner.de/api/badge?name=infrastructure&revision=true)](https://argocd.robert-wiesner.de/applications/infrastructure)     |
 

## Upgrade ArgoCD
- argocd can be upgraded by changing the [helm chart](https://artifacthub.io/packages/helm/argo/argocd) versions in [Chart.yml](bootstrap/argocd-app-of-apps/templates/argoCd.yaml)

# Debug
- If you messed up Traefik or ArgoCD config, you can always port-forward:
  - `kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n traefik) 9000:9000 -n traefik`
  - `kubectl port-forward svc/argocd-server -n argocd 8080:443`

# TODOs
- [ ] Infrastructure is not templated
- [X] Google SSO for ArgoCD
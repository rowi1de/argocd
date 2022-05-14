#!/bin/sh

argoByArgo=$(kubectl get Application argo-cd -n argo-cd -o json | jq -r '.status.health.status')
if [ "$argoByArgo" = "Healthy" ]
then
     printf "argo-cd already managed by argo-cd, skipping bootstrap."
else

    cd argo-cd || exit
    helm repo add argo https://argoproj.github.io/argo-helm
    helm dependency update && helpm dependency build
     az aks command invoke \
         --resource-group $AZURE_RESOURCE_GROUP  \
         --name $AZURE_CLUSTER_NAME \
         --command "helm repo add argo https://argoproj.github.io/argo-helm"

   az aks command invoke \
     --resource-group $AZURE_RESOURCE_GROUP  \
     --name $AZURE_CLUSTER_NAME \
     --command "helm upgrade --install argo-cd . --namespace argo-cd --create-namespace --atomic --wait" \
     --file .
    cd "../"
fi

appOfAppsByArgo=$(kubectl get Application app-of-apps -n argo-cd -o json | jq -r '.metadata.labels."argocd.argoproj.io/instance"')
if [ "$appOfAppsByArgo" = "app-of-apps" ]
then
     printf "\n%s already managed by argo-cd, skipping bootstrap."  "$appOfAppsByArgo"
     exit 0
else
    if [ -z "$GITHUB_TOKEN" ]
    then
          echo "\$GITHUB_TOKEN is empty"
          exit 1
    fi

    cd argo-cd-app-of-apps || exit
    az aks command invoke \
         --resource-group $AZURE_RESOURCE_GROUP  \
         --name $AZURE_CLUSTER_NAME \
         --command "helm upgrade --install app-of-apps . --namespace argo-cd --create-namespace --atomic --wait --set secret=$GITHUB_TOKEN" \
         --file .
fi
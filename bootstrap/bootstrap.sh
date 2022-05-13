#!/bin/sh

argoByArgo=$(kubectl get Application argo-cd -n argo-cd -o json | jq -r '.status.health.status')
if [ "$argoByArgo" = "Healthy" ]
then
     printf "argo-cd already managed by argo-cd, skipping bootstrap."
else
    helm repo add argo https://argoproj.github.io/argo-helm
    cd argo-cd || exit
    helm dependency build
    helm upgrade --install argo-cd . --namespace argo-cd --create-namespace --atomic --wait
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
    helm upgrade --install app-of-apps . --namespace argo-cd --create-namespace --atomic --wait --set secret="$GITHUB_TOKEN"
fi
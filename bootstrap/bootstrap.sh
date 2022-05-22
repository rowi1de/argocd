#!/bin/sh

REPO=https://github.com/rowi1de/argocd
DOMAIN=robert-wiesner.dey
ARGOCD_DOMAIN="https://argocd.$DOMAIN"
read -r -p "Using Cluster Repo: $REPO, Domain: $ARGOCD_DOMAIN, are you sure? [y/N] " response
# shellcheck disable=SC2039
if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    exit 0
fi
exit 0
argoByArgo=$(kubectl get Application argocd -n argocd -o json | jq -r '.status.health.status')
if [ "$argoByArgo" = "Healthy" ]; then
    printf "argocd already managed by argocd, skipping bootstrap."
else
    helm repo add argo https://argoproj.github.io/argo-helm
    cd argocd || exit
    helm dependency update && helpm cd dependency build
    helm upgrade --install argocd . -f values.yaml --set argocd.config.server=$ARGOCD_DOMAIN --namespace argocd --create-namespace --atomic --wait
    cd "../"
fi

appOfAppsByArgo=$(kubectl get Application app-of-apps -n argocd -o json | jq -r '.metadata.labels."argocd.argoproj.io/instance"')
if [ "$appOfAppsByArgo" = "app-of-apps" ]; then
    printf "\n%s already managed by argocd, skipping bootstrap." "$appOfAppsByArgo"
    exit 0
else
    echo "Input a GitHub Personal Access Token with access to this repo:"
    # shellcheck disable=SC2039
    read -s -r GITHUB_TOKEN
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "\$GITHUB_TOKEN is empty"
        exit 1
    fi

    cd argocd-app-of-apps || exit
    echo "Creating temporary repo secret for initial sync (temp-repo-secret in argocd)"
    kubectl create secret generic temp-repo-secret -n argocd \
        --from-literal=type=git \
        --from-literal=url=$REPO \
        --from-literal=password=$GITHUB_TOKEN
    helm upgrade --install app-of-apps . --namespace argocd --create-namespace --set domain="$ARGOCD_DOMAIN",repo="$REPO",secret="$GITHUB_TOKEN" --atomic --wait --dry-run

    echo "Tyring to login to argocd ..."
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    argocd login localhost:8080 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}")
    echo "Waiting for sealed-secrets app ..."
    argocd app wait sealed-secrets --health

    echo "Creating sealed repo-secret ..."
    kubectl create secret generic repo-secret -n argocd --dry-run=client \
        --from-literal=type=git \
        --from-literal=url=$REPO \
        --from-literal=password=$GITHUB_TOKEN \
        -o yaml | kubeseal --controller-namespace infrastructure --controller-name sealed-secrets -o yaml \
        >! templates/SealedSecret.yaml
    echo "Please git commit and push new secret ..."
    kubectl delete secret temp-repo-secret -n argocd
    argocd app sync app-of-apps
fi

unset GITHUB_TOKEN

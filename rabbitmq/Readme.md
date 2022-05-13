# RabbitMQ
- We use RabbitMQ on k8s for dev (currently)

## Operator
- [bitnami/rabbitmq-cluster-operator](https://artifacthub.io/packages/helm/bitnami/rabbitmq-cluster-operator)
- See [rabbitmq-cluster-operator](./rabbitmq-cluster-operator.yaml)
- The operator is deployed in "rabbitmq" namespace, see [![App Status](https://argocd.robert-wiesner.de/api/badge?name=rabbitmq-cluster-operator&revision=true)](https://argocd.robert-wiesner.de/applications/rabbitmq-cluster-operator)

## Cluster
- See [rabbitmq-cluster](../rabbitmq-cluster)

## Cluster
- See [cluster-operator/examples](https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples)
```shell
kubectl get rabbitmqclusters.rabbitmq.com --namespace dev
```

### Admin UI
- [RabbitMQ Admin UI](https://rabbitmq-admin.robert-wiesner.de) with [Credentials](https://start.1password.com/open/i?a=YNPNX4CAYBDGNKT55YJ5HQ2Z24&v=wzb5qr74gidvj7h6h5bples3e4&i=hep3i7o6j5bdjfegglju4mptjq&h=reev.1password.eu)
- Use the following (or lens) to get the initial credentials after deploy:
```shell
username="$(kubectl -n dev get secret rabbitmq-cluster-default-user    -o jsonpath='{.data.username}' | base64 --decode)"
echo "username: $username"
password="$(kubectl -n dev get secret rabbitmq-cluster-default-user    -o jsonpath='{.data.password}' | base64 --decode)"
echo "password: $password"
```

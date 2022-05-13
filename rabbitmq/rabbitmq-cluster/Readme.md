# RabbitMQ Cluster

- Needs [rabbitmq-cluster-operator](../rabbitmq-cluster-operator.yaml) deployed
- See [cluster-operator/examples](https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples)
```shell
kubectl get rabbitmqclusters.rabbitmq.com --namespace dev
```
## Develop
- This chart includes the library chart [utils](../../helm/library/utils/Chart.yaml) as dependency
- On changes of the library chart run `helm dependency update && helm dependency build`

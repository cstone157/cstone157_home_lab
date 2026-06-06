# Elstaic Stack

## Instruction from website

- https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/managing-deployments-using-helm-chart

## Helm-chart

- Install the elasitc repository

```
helm repo add elastic https://helm.elastic.co
helm repo update
```

- Install an eck-managed Elasticsearch and Kibana using the default values, which deploys the quickstart examples.

```
helm install es-kb-quickstart elastic/eck-stack -n elastic-stack --create-namespace
```	



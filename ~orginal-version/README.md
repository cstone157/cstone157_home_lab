# data_lake_example
A simplified example of the data-lake using Kubernetes

# Cloning project:

# Setup of Kubernetes

# PgAdmin
#### Connecting pgAdmin to postgres using the IP ($ kubectl get all -o wide) for the postgres pod or using the name given in the services (postgres)

# NOTES:
#### - To encode something using base64:
    - $ echo -n 'root' | base64

<br/>

# KUBERNETES:
#### - Get all resources
    - $ kubectl get all
    - $ kubectl get all -n stone-data-lake
#### - Delete all resources
    - $ kubectl delete --all namespaces
#### - Connect to a pod and access it's commandline.
    - $ kubectl exec -it <pod-name> -- /bin/bash
#### - Get the logs of our pod
    - $ kubectl logs <pod-name>
#### - Get the description of a pod
    - $ kubectl describe pod <pod-name>
#### - Delete all Persistent volumes
    - $ kubectl delete pvc --all 
#### -
    - $ kubectl apply -f <file_name>
    - $ envsubst < <file_name> | kubectl apply -f -

# RESOURCES
##### - https://dev.to/dm8ry/how-to-deploy-postgresql-db-server-and-pgadmin-in-kubernetes-a-how-to-guide-5fm0
##### - https://medium.com/@lukhee/aws-deploying-mongo-database-image-to-aws-eks-4916d7883c9f
##### - https://overcast.blog/provisioning-kubernetes-local-persistent-volumes-full-tutorial-147cfb20ec27
##### - https://www.keycloak.org/operator/basic-deployment


## Note - Pausing to work on adding a plugin to mace, was working on adding the OAuth to the PgAdmin server.  Files created, secret not being passed around, need to update the sh to generate and insert into the necissary files prior to creating the DockerImages.

##### - https://www.olavgg.com/show/how-to-configure-pgadmin-4-with-oauth2-and-keycloak
##### - https://www.pgadmin.org/docs/pgadmin4/latest/config_py.html

## Install Kubernetes on linux
##### - https://linuxconfig.org/how-to-install-kubernetes-on-linux-mint
## Install docker/curl
$ sudo apt update
$ sudo apt install curl docker.io
## Start/enable docker
$ sudo systemctl start docker
$ sudo systemctl enable docker
## Disable swap space
$ sudo swapoff -a
$ sudo sed -i '/ swap / s/^/#/' /etc/fstab
## Download minikube installer
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
## Install the package
$ sudo dpkg -i minikube_latest_amd64.deb
## Setup minikube
$ minikube start
$ minikube start --driver=docker
$ minikube kubectl -- get po -A
$ alias kubectl="minikube kubectl --"
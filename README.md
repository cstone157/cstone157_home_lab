## Files

### Building custom images

    - https://snyk.io/blog/building-docker-images-kubernetes/
    - 

### Local image repository

### Postgres

### PgAdmin

### Ollama


### Accessing applications

    - URLs
        - WebUI : http://localhost:30000
        - PgAdmin : http://localhost:30010
        - Nifi : 


## Setup

### Steps to setup (v1) - DELTE ME (https://sarinsuriyakoon.medium.com/deploy-ollama-on-local-kubernetes-microk8s-6ca22bfb7fa3)

    - Install deployment and the service
    - Remote into the application and install a model
        - $ ollama pull llama2
    - Test to ensure that the model successfully installed
        - $ curl localhost:11434 -d '{ "model": "llama2", "prompt":"Why is the sky blue?" }'


## Sources

### Source of kubernetes.yaml : https://github.com/open-webui/open-webui/
### https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/

    - Run the command ("kubectl apply -f" for file and "kubectl apply -k" for kustomization file/folder)
        - $ kubectl apply -k ./kubernetes/manifest/base
    - Remote into the application and install a model
        - $ ollama pull llama2
        - OR
        - $ ollama pull llama3.1 - Seems to be crashing
    - Test to ensure that the model successfully installed
        - $ ollama run llama2 'Why is the sky blue?'
        - 
        - $ curl http://localhost:11434/api/generate -d '{ "model": "llama2", "prompt":"Why is the sky blue?" }'
        - OR
        - $ curl http://localhost:11434/api/generate -d '{ "model": "llama3.1", "prompt":"Why is the sky blue?" }'



## ========================================================== OLD ==========================================================

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
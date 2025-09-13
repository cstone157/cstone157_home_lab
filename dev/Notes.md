# Setup development enviroment

## 1.) Local setup / requirements

- Install Rancher Desktop (RKE) (https://docs.rancherdesktop.io/getting-started/installation/)
- Install Helm
- 

## 2.) Setup Development Enviroment

- Installing Certificate manager (jetstack/cert-manager)
    - Install using helm:
        - Add the Jetstack Helm repository:
        - <code>$ helm repo add jetstack https://charts.jetstack.io</code>
        - Update your Helm repositories:
        - <code>$ helm repo update</code>
        - Install cert-manager using Helm:
        - <code>$ helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.2 --set installCRDs=true</code>
    - Verify the Installation:
        - After installing cert-manager using either method, it's crucial to verify that the installation was successful.
        - <code>$ kubectl get pods --namespace cert-manager</code>
        - You can also check the status of the Custom Resource Definitions (CRDs)
        - Windows: <code>$ kubectl get crds</code>, Linux <code>$ kubectl get crds | grep cert-manager</code>
    - Setting up an Issuer:
        - cert-manager itself doesn't issue certificates. You need to configure an Issuer or ClusterIssuer resource to define how certificates will be obtained.
        - <code>$ kubectl apply -f cert-manager/letsencrypt-staging-clusterissuer.yaml</code>

- Installing Docker Registry to Kubernetes (registry:2)
    - Create namespace:
        - <code>$ kubectl create namespace registry</code>
    - Create a Persistent Volume Claim (PVC):
        - <code>$ kubectl apply -f registry/registry-pvc.yaml</code>
    - Create a Docker Registry Deployment:
        - <code>$ kubectl apply -f registry/registry-deployment.yaml</code>
    - Create a Docker Registry Service:
        - <code>$ kubectl apply -f registry/registry-service.yaml</code>
    - Create an Ingress Resource with cert-manager Integration:
        - <code>$ kubectl apply -f registry/registry-ingress.yaml</code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>








    - :
        - <code>$ </code>















































### Install Certificate manager (jetstack/cert-manager)

- Install Certificate manager (jetstack/cert-manager)
    - Add the Jetstack Helm Repository:
        - <code>$ helm repo add jetstack https://charts.jetstack.io</code>
        - <code>$ helm repo update</code>
    - Create a Namespace (Recommended):
        - <code>$ kubectl create namespace cert-manager</code>
    - Install the cert-manager Helm Chart:
        - <code>$ helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.14.3 --set installCRDs=true</code>
    - Verify the Installation:
        - <code>$ kubectl -n cert-manager get pods</code>
        - <code>$ kubectl -n cert-manager get deployments</code>
        - <code>$ kubectl -n cert-manager get crds</code>
        - Or
        - <code>$ kubectl -n cert-manager get pods,deployments,crds</code>
    - Check Cert-manager logs:
        - <code>$ kubectl logs -n cert-manager -l app.kubernetes.io/name=cert-manager</code>

- Post-Installation Configuration:
    - Create a ClusterIssuer (Let's Encrypt): see cert-manager/letsencrypt-clusterissuer.yaml
    - Apply the ClusterIssuer:
        - <code>$ kubectl apply -f cert-manager/letsencrypt-clusterissuer.yaml</code>
    - Create a Certificate: see cert-manager/my-website-certificate.yaml
    - Apply the Certificate:
        - <code>$ kubectl apply -f cert-manager/my-website-certificate.yaml</code>
    - Configure your Ingress: see cert-manager/my-website-ingress.yaml

### Install Registry

- Installing Dcoker Registry
    - Create namespace:
        - <code>$ kubectl create namespace registry</code>
    - Create a Persistent Volume Claim (PVC): see registry/registry-pvc.yaml
    - Apply the pvc:
        - <code>$ kubectl apply -f registry/registry-pvc.yaml</code>
    - Verify that the PVC is bound to a Persistent Volume (PV):
        - <code>$ kubectl get pvc -n registry registry-data</code>
    - Create a Deployment for the Registry: see registry/registry-deployment.yaml
    - Apply the Deployment:
        - <code>$ kubectl apply -f registry\registry-deployment.yaml</code>
    - Verify that the pod is running:
        - <code>$ kubectl get pods -n registry -l app=docker-registry</code>
    - Create a Service for the Registry: see registry\registry-service.yaml
    - Apply the Service:
        - <code>$ kubectl apply -f registry\registry-service.yaml</code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>

        - <code>$ </code>

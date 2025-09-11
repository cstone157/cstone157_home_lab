# Setup development enviroment

## 1.) Local setup / requirements

- Install Rancher Desktop (RKE) (https://docs.rancherdesktop.io/getting-started/installation/)
- 

## 2.) Setup Kubernetes 

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
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>






        - <code>$ </code>

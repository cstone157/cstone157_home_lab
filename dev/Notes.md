# Setup development enviroment

## 1.) Local setup / requirements

- Install Rancher Desktop (RKE) (https://docs.rancherdesktop.io/getting-started/installation/)
- Install Helm

## 2.) Setup Development Enviroment

- Installing Certificate manager (jetstack/cert-manager) (https://cert-manager.io/docs/installation/helm/) (https://medium.com/geekculture/a-simple-ca-setup-with-kubernetes-cert-manager-bc8ccbd9c2)
    - Prerequisites:
        - Install helm (https://helm.sh/docs/intro/install/)
        - Install kubernetes (https://cert-manager.io/docs/releases/)
    - Installing from the OCI Registry
        - For simplicity, the cert-manager Helm charts are published to the same OCI registry as the cert-manager container images, at quay.io/jetstack
        - <code>$ helm install cert-manager oci://quay.io/jetstack/charts/cert-manager --version v1.18.2 --namespace cert-manager --create-namespace --set crds.enabled=true</code>

- Test cert-manager for self-signed certificate / use it to setup an ingress controller (Example)
    - Create the namespace:
        - <code>$ kubectl create namespace test</code>
    - Create the issuer:
        - <code>$ kubectl apply -f cert-manager/01-cert-manager-ss-issuer.yaml</code>
    - Create the certificate:
        - <code>$ kubectl apply -f cert-manager/02-cert-manager-ca-cert.yaml</code>
    - Inspect the certificate:
        - <code>$ kubectl -n test get certificate</code>
    - Inspect the secret:
        - <code>$ kubectl -n test get secret test-ca-secret</code>
    - Create our CA issuer:
        - <code>$ kubectl apply -f cert-manager/03-cert-manager-ca-issuer.yaml</code>
    - Important to note here is that we will be using an Issuer and not a ClusterIssuer. The main difference between the two is that an Issuer can only issue certificates within the same namespace! If you want your CA to issue certificates in other namespaces as well, you will have to use the ClusterIssuer. See the <a href="https://cert-manager.io/docs/configuration/ca/">cert-manager documentation</a> for more info about this.
    - Issue CA Signed Certificate:
        - <code>$ kubectl apply -f cert-manager/04-test-server-cert.yaml</code>
    - First validate if our server certificate against our CA:
        - <code>$ openssl verify -CAfile <(kubectl -n test get secret test-ca-secret -o jsonpath='{.data.ca\.crt}' | base64 -d) <(kubectl -n test get secret test-server-tls -o jsonpath='{.data.tls\.crt}' | base64 -d)</code>
    - Let’s now create a test server so we can try out our client certificate. Using openssl s_server utility, launch a server:
        - <code>$ echo Hello World! > test.txt</code>
        - <code>$ openssl s_server -cert <(kubectl -n test get secret test-server-tls -o jsonpath='{.data.tls\.crt}' | base64 -d) -key <(kubectl -n test get secret test-server-tls -o jsonpath='{.data.tls\.key}' | base64 -d) -CAfile <(kubectl -n test get secret test-server-tls -o jsonpath='{.data.ca\.crt}' | base64 -d) -WWW -port 12345  -verify_return_error -Verify 1</code>
        - Our little test server running on port 12345 will serve Hello World! if all goes ok. Test it out as follows
        - <code>$ echo -e 'GET /test.txt HTTP/1.1\r\n\r\n' | openssl s_client -cert <(kubectl -n test get secret test-client-tls -o jsonpath='{.data.tls\.crt}' | base64 -d) -key <(kubectl -n test get secret test-client-tls -o jsonpath='{.data.tls\.key}' | base64 -d) -CAfile <(kubectl -n test get secret test-client-tls -o jsonpath='{.data.ca\.crt}' | base64 -d) -connect localhost:12345 -quiet</code>
    - Echo Server Setup with CA Signed Certificate:
        - Let’s try our setup with a simple echo server using Ingress. When using minikube be sure to enable ingress:
        - <code>$ kubectl create -f cert-manager/05-echo-server.yaml</code>
    - Edit the hosts file to include:
        - <code>127.0.0.1    echo.info</code>
        - The location of the hosts file varies by operating system:
            - Windows: C:\Windows\System32\drivers\etc\hosts
            - /etc/hosts
    - Enable network tunneling (if necissary)
        - 
    - Test the connection
        - <code>$ curl --cacert <(kubectl -n test get secret echo-server-cert -o jsonpath='{.data.ca\.crt}' | base64 -d) https://echo.info/test</code>



- Installing registry manager (https://hub.docker.com/_/registry)


Okay, let's craft a YAML configuration to deploy a registry:2 container with a self-signed certificate, leveraging cert-manager. Here's the breakdown and the YAML file.
Understanding the Approach
cert-manager: We'll use cert-manager to generate a self-signed certificate. This is a good way to get a secure registry up and running for development or internal testing, without needing a public Certificate Authority (CA).
Issuer: We'll define a ClusterIssuer (because it's usually better for cluster-wide availability) to create the certificate. The ClusterIssuer will use the selfSigned type.
Certificate: We'll create a Certificate resource that instructs cert-manager to generate a certificate based on our ClusterIssuer. This Certificate will specify the domains/hostnames the certificate is valid for. The resulting certificate and private key will be stored in a Kubernetes Secret.
Deployment: The Deployment will deploy the registry:2 container. It's crucial that the Deployment mounts the certificate and key from the Secret generated by cert-manager.
Service: A Kubernetes Service will expose the registry. We'll create a NodePort service to allow access from outside the cluster, or a ClusterIP for internal access.
Ingress (Optional): An Ingress can provide a stable and well-known hostname for the registry. It also handles TLS termination. This is a good approach for larger clusters or for when you have multiple services behind a single IP.
YAML Configuration (registy.yaml)

Important Considerations and Customization
registry.example.com: Replace all instances of registry.example.com with the actual domain or hostname you want to use for your registry. If you are testing locally, you can use an IP address or localhost.localdomain, but you'll need to add this domain to your /etc/hosts file on your machine, pointing it to the IP address of a node that the registry service is running on.
Namespace: The Certificate is deployed in the default namespace. Change this if you want to deploy it elsewhere. Make sure the deployment and service are in the same namespace.
Storage: The example uses an emptyDir for the registry's data. This means that data will be lost if the pod is restarted. For production use, absolutely use a persistent volume claim (PVC). Define a PVC and change the volume definition in the Deployment to use a persistentVolumeClaim instead of emptyDir.
NodePort vs ClusterIP vs Ingress:
NodePort is simplest for exposing the registry, but it uses a port on each node in the cluster. You would then access the registry by navigating to one of the node's IP address and that nodeport number, using HTTPS.
ClusterIP makes the registry only accessible from within the cluster. Useful if only other pods/services need to access it.
Ingress is the most flexible. It uses an Ingress controller (like nginx-ingress, traefik, etc.) to handle routing and TLS termination. You'll need an Ingress controller set up in your cluster already for this to work. The advantage is that you can have a proper hostname, and you don't have to expose a node port.
Ingress Class: In the Ingress definition, kubernetes.io/ingress.class: "nginx" specifies the Ingress controller. Adapt this to the correct class for your Ingress controller (e.g., "traefik").
Self-Signed Certificate Security: Remember that self-signed certificates are not trusted by default by browsers or other clients. You'll need to configure your clients to trust the certificate. This is fine for development, but strongly consider a real certificate authority (Let's Encrypt, etc.) for production.
Rancher integration: The YAML will work fine in a Rancher-managed cluster. You can apply it through the Rancher UI or using kubectl.
Deployment Steps
Save the YAML: Save the above YAML as all-in-one.yaml (or any name you prefer).
Apply the YAML: Use kubectl apply -f all-in-one.yaml to deploy the resources. If you are using Rancher's UI, you can paste the YAML directly into the editor when creating a new workload.
Verify the Deployment:
kubectl get pods (check that the registry pod is running)
kubectl get svc (check the service)
kubectl get certificate (check that the certificate is issued successfully)
kubectl get secret registry-tls (check that the secret was created and contains tls.crt and tls.key)
Access the Registry: Based on your Service type, access the registry.
NodePort: Find the IP address of one of your Kubernetes nodes. Access the registry using https://<node-ip>:<node-port>. You will likely have to bypass browser security warnings because of the self-signed certificate.
Ingress: If you have an Ingress controller configured, make sure the DNS for your domain (e.g., registry.example.com) points to the IP address of your Ingress controller. Then, access the registry using https://registry.example.com.
Example Usage (after successful deployment)
To push an image to the registry:
Tag the image:
code
Bash
docker tag my-image:latest registry.example.com/my-image:latest
Log in to the registry:
code
Bash
docker login registry.example.com
# Provide username (if any) and password.  You might need to bypass certificate validation.
Push the image:
code
Bash
docker push registry.example.com/my-image:latest
Remember to adapt the domain name to your actual setup. If you are pushing from outside the cluster, and you used a NodePort service, you will need to access it using the IP address of one of the kubernetes nodes and the port specified in the NodePort section of the service definition. You might need to configure docker to trust the self-signed certificate if you have not already.
This detailed guide should get you a registry:2 instance running securely (enough for development purposes) within your Kubernetes cluster. Remember to replace the placeholder values with your actual configuration. And, for production, seriously consider using a real TLS certificate.

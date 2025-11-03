# Setup development enviroment

## 1.) Local setup / requirements

- Install Rancher Desktop (RKE) (https://docs.rancherdesktop.io/getting-started/installation/)
- Install Helm
- 

## 2.) Setup Development Enviroment

- Installing Certificate manager (jetstack/cert-manager) (https://cert-manager.io/docs/installation/helm/) (https://medium.com/geekculture/a-simple-ca-setup-with-kubernetes-cert-manager-bc8ccbd9c2)
    - Prerequisites:
        - Install helm (https://helm.sh/docs/intro/install/)
        - Install kubernetes (https://cert-manager.io/docs/releases/)
    - Installing from the OCI Registry
        - For simplicity, the cert-manager Helm charts are published to the same OCI registry as the cert-manager container images, at quay.io/jetstack
        - <code>$ helm install cert-manager oci://quay.io/jetstack/charts/cert-manager --version v1.18.2 --namespace cert-manager --create-namespace --set crds.enabled=true</code>

- Test cert-manager / use it to setup an ingress controller
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
        - <code>$ kubectl create -f cert-manager/echo-server.yaml</code>
    - Edit the hosts file to include:
        - <code>127.0.0.1    echo.info</code>
        - The location of the hosts file varies by operating system:
            - Windows: C:\Windows\System32\drivers\etc\hosts
            - /etc/hosts
    - Enable network tunneling



    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>
    - :
        - <code>$ </code>

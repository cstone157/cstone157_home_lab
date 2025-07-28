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
        - JupyterLab : http://localhost:30020
        - WebUI : http://localhost:30000
            - Add a connection under Admin/Settings for : http://ollama-service:11434
        - PgAdmin : http://localhost:30010
        - Nifi : http://localhost:31000
            - https : http://localhost:31001
            - tcp port 1 : localhost:31011
            - tcp port 2 : localhost:31012
            - tcp port 3 : localhost:31013
            - tcp port 4 : localhost:31014
            - udp port 1 : localhost:31021
            - udp port 2 : localhost:31022
            - udp port 3 : localhost:31023
            - udp port 4 : localhost:31024

## Setup

    - <code>$ helm install <name> ./helm</code>




### =============================================== OLD VERSION ===============================================

### Steps to setup (v1) - DELTE ME (https://sarinsuriyakoon.medium.com/deploy-ollama-on-local-kubernetes-microk8s-6ca22bfb7fa3)

    - Apply kustomization : 
<code>$ kubectl apply -k ./kube/vi/ </code>
    - Remote into the ollama pod and install a model
<code>$ kubectl exec -it -n=lab-test ollama-0 -- sh</code><br><code># ollama pull llama2</code>
    - Test to ensure that the model successfully installed
<code># ollama run llama2 "Why is the sky blue?" </code><br />
<code># curl localhost:11434 -d '{ "model": "llama2", "prompt":"Why is the sky blue?" }'</code>

### Build images

#### Rancher Desktop

    - Use "nerdctl build" to build image and the "images to upload you image"

## Sources

    - Source of kubernetes.yaml : https://github.com/open-webui/open-webui/
    - https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/

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

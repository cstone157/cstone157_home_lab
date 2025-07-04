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


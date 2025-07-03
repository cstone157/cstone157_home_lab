# https://sarinsuriyakoon.medium.com/deploy-ollama-on-local-kubernetes-microk8s-6ca22bfb7fa3

### Steps to setup

    - Install deployment and the service
    - Remote into the application and install a model
        - $ ollama pull llama2
    - Test to ensure that the model successfully installed
        - $ curl localhost:11434 -d '{ "model": "llama2", "prompt":"Why is the sky blue?" }'
    - 

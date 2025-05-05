#!/bin/bash

## Add our util and variables functions
source ./scripts/utils.sh
source ./scripts/variables.sh



# Check if the commands we need to run are installed
if ! command -v envsubst &> /dev/null
then
    printf "envsubst could not be found, used for substitutions.  Please install with something like:\n     $ apt-getg y install getext-base\nInstallation, with vary based on distro.\n"
    exit 1
fi

# Check if we have kubectl or minikube enabled
if ! command -v kubectl &> /dev/null
then
    if ! command -v minikube &> /dev/null
    then
        printf "kubectl and minikube not found, please fix"
        exit 1
    else
        kubectl="minikube kubectl --"
    fi
else
    kubectl="kubectl"
fi

_command="$1"
## ========== EXECUTE THE CLEANUP COMMAND BLOCK ===========
if [ "$_command" == "cleanup" ]; then
    source ./scripts/cleanup.sh
    cleanupCommand $2
## ============== EXECUTE BUILD COMMAND BLOCK =============
elif [ "$_command" == "build" ]; then
    kubectl kustomize k8s
    # source ./scripts/build.sh
    # buildCommand $2
# ## ============= EXECUTE STATUS COMMAND BLOCK =============
# elif [ "$_command" == "status" ]; then
#     get_status
# ## ================ OPEN PODS COMMAND LINE ================
# elif [ "$_command" == "exec" ]; then
#     $kubectl exec -it -n stone-data-lake pod/keycloak-d67848c6-xkvm9 -- sh
# ## ============= TEMP REGISTRY COMMAND BLOCK =============
# elif [ "$_command" == "registry" ]; then
#     source ./scripts/build.sh
#     buildRegistry

else
    printf "Unknown command\n\tOnly recognized commands:\n\t\tcleanup - \n\t\tbuild - \n\t\tstatus - \n\t\texec - Don't use exec, it won't work\n\t\tregistry - \n"
fi

## =================================================================================================================================================================================
##                                                                      Purge our K8S and/or Docker enviroment                                                                      
## =================================================================================================================================================================================
function cleanupCommand {
    docker=false
    kubernetes=false

    if [ -z ${1+x} ] || [ $1 == "--help" ]; then
        printf "When using the cleanup command, you need to specify:\n\t-a\tClean everything (kubernetes and docker)\n\t-k\tClean Kubernetes\n\t-d\tClean Docker\n"
        exit 0
    elif [ $1 == "-a" ]; then
        docker=true
        kubernetes=true
    elif [ $1 == "-k" ]; then
        kubernetes=true
    elif [ $1 == "-d" ]; then
        docker=true
    fi

    clear
    ## If any of our parameters are kubernetes, then go ahead and cleanup our kubernetes enviroment
    if [ $kubernetes == true ]; then
        printf "== Start Cleaning up our Kubernetes data-lake enviroment\n"
        # V1
        # kubectl delete namespace stone-data-lake
        # kubectl delete pvc --all
        # kubectl delete pv keycloak-pv postgres-pv
        # kubectl delete pv --all
        # kubectl delete secrets --all
        # kubectl delete pvc --all & kubectl delete pv --all & kubectl delete secrets --all
        # kubectl delete namespace stone-data-lake & kubectl delete pvc --all & kubectl delete pv --all & kubectl delete secrets --all & kubectl delete configmap --all

        # V2
        # $kubectl delete namespace stone-data-lake && $kubectl delete pvc --all && $kubectl delete pv --all && $kubectl delete secrets --all && $kubectl delete configmap --all

        #$kubectl delete -f k8s/kustomization.yaml
        #$kubectl kustomize k8s/
    fi

    # ## If any of our parameters are docker, then go ahead and cleanup our docker enviroment
    # if [ $docker == true ]; then
    #     if [ $kubernetes == true ]; then
    #         printf "\nWaiting for Kubernetes to finish actions:\n"
    #         pause_script 20
    #     fi

    #     printf "\n== Start Cleaning up our Docker data-lake enviroment"
    #     docker image rm localhost:5000/data-lake-postgres localhost:5000/data-lake-pgadmin localhost:5000/data-lake-keycloak
    #     docker container stop registry
    #     docker container rm registry
    # fi
}
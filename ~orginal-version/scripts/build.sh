# ## Helper function for creating a k8s pod
# function add_jupyter_k8s_pod {
#     _local_volume_path=$(pwd)
#     _local_volume_path="$_local_volume_path/jupyter/work"
#     read -p "If you want to use a local volume (storage) for the JupyterHub's work directory. \nDefault will be $_local_volume_path, NA to not use a local volume: " _user_specified_path

#     name="Jupyter"
#     path="jupyter/jupyter.yaml"

#     if [ $_user_specified_path != "NA" ]:
#     then
#         if [ $_user_specified_path != "" ]:
#         then
#             _local_volume_path=$_user_specified_path
#         fi

#         path="jupyter/jupyter-w-local.yaml"
#         eval 'export _local_volume_path="$_local_volume_path"'
#     fi

#     printf "\n=============================================================================\nExecuting the $path, to create the service $name\n"
#     envsubst < $path | $kubectl apply -f -
# }

# ## =================================================================================================================================================================================
# ##                                                                      Deploy a registry to Docker
# ## =================================================================================================================================================================================
# function buildRegistry {
#     registry_status="$(docker ps -f 'name=registry')"
#     if [[ "$registry_status" =~ "registry" ]]; then
#         printf "Registry container already exists:\n"
#     else
#         printf "Creating Docker registry container:\n"
#         docker run -d -p $registry_port:$registry_image_port --restart=always --name registry registry:2
#     fi
# }

# ## =================================================================================================================================================================================
# ##                                                                      Build our Docker Images and deploy to the registry
# ## =================================================================================================================================================================================
# function buildDockerImages {
#     ## Local Registry
#     buildRegistry

#     ### Build my dockerfiles
#     printf "\nBuilding our docker image and configuration files\n"

#     #### Postgres has some build files that need to be setup first
#     touch postgres/preloaded_data/01-keycloak.sql
#     envsubst < postgres/preloaded_data/01-keycloak > postgres/preloaded_data/01-keycloak.sql
    
#     #### PgAdmin / Keycloak need their client key to be set to be created
#     ####    successfully.
#     touch keycloak/clients/pgadmin.json
#     envsubst < keycloak/clients/pgadmin > keycloak/clients/pgadmin.json
#     touch pgadmin/pgadmin.json
#     envsubst < pgadmin/config_local > pgadmin/config_local.py

#     #### Jupyter Dockerfile update
#     touch jupyter/Dockerfile
#     envsubst < jupyter/Dockerfile.org > jupyter/Dockerfile


#     docker build ./postgres/ -t localhost:$registry_port/data-lake-postgres
#     docker build ./keycloak/ -t localhost:$registry_port/data-lake-keycloak
#     docker build ./pgadmin/ -t localhost:$registry_port/data-lake-pgadmin
#     docker build ./jupyter/ -t localhost:$registry_port/data-lake-jupyter
    
#     ## Clean-up our scripts with secrets
#     rm postgres/preloaded_data/01-keycloak.sql
#     rm keycloak/clients/pgadmin.json   # Key-cloak Auth configured json
#     rm pgadmin/config_local.py         # Key-cloak Auth configured py
#     rm jupyter/Dockerfile              # Jupyter dockerfile with client key

#     ### Push the docker-image to the local registry
#     printf "\nPush the docker-image to the registry\n"
#     docker push localhost:$registry_port/data-lake-postgres
#     docker push localhost:$registry_port/data-lake-keycloak
#     docker push localhost:$registry_port/data-lake-pgadmin
#     docker push localhost:$registry_port/data-lake-jupyter
# }

# ## =================================================================================================================================================================================
# ##                                                                      Build our Kubernetes Enviroment                                                                      
# ## =================================================================================================================================================================================
# function buildKubernetes {
#     ## Create data-lake
#     ### Setup the namespace, configmap, and secrets
#     envsubst < data-lake.yaml | $kubectl apply -f -

#     ### Setup the postgresql pods
#     horizontal_seperator "Setup Postgres Pod"
#     envsubst < postgres/postgres.yaml | $kubectl apply -f -

#     ### Setup the pgadmin pod / service
#     horizontal_seperator "Setup PgAdmin Pod"
#     envsubst < pgadmin/pgadmin.yaml | $kubectl apply -f -

#     ### Delay 5 seconds to let postgres have some time to setup before Keycloak starts
#     sleep 5s
#     ### Setup the Keycloak pod / service
#     horizontal_seperator "Setup Keycloak Pod"
#     envsubst < keycloak/keycloak.yaml | $kubectl apply -f -


#     ### Setup the Keycloak pod / service
#     horizontal_seperator "Setup Jupyter Pod"
#     envsubst < jupyter/jupyter.yaml | $kubectl apply -f -


#     ### ============== Show all of our relavent pods / services ==============
#     horizontal_seperator "Results"
#     get_status
# }


# ## =================================================================================================================================================================================
# ##                                                                      Build our K8S and/or Docker enviroment                                                                      
# ## =================================================================================================================================================================================
# function buildCommand {
#     docker=false
#     kubernetes=false

#     if [ -z ${1+x} ] || [ $1 == "--help" ]; then
#         printf "When using the build command, you need to specify:\n\t-a\tBuild everything (kubernetes and docker)\n\t-k\tBuild Kubernetes\n\t-d\tBuild Docker"
#         exit 0
#     elif [ $1 == "-a" ]; then
#         docker=true
#         kubernetes=true
#     elif [ $1 == "-k" ]; then
#         kubernetes=true
#     elif [ $1 == "-d" ]; then
#         docker=true
#     fi

#     ## Clear the screen & Build all of our variables
#     clear
#     build_variables

#     if [ $docker == true ]; then
#         buildDockerImages
#     fi

#     if [ $kubernetes == true ]; then
#         if [ $docker == true ]; then
#             printf "\n"
#         fi
#         printf "Start Setting up our Kubernetes data-lake enviroment\n"
#         buildKubernetes
#     fi
# }
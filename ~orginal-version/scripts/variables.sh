## We use our registry port for everything, so go ahead and just export it no matter what
export registry_port=5000
export registry_image_port=5000

function build_variables {
    ## Build our enviroment variables that we will need
    ### Create our keycloak database user & password
    keycloak_db="keycloak"
    keycloak_db_username="keycloak"
    keycloak_db_password="keycloak-password"
    export keycloak_db_username="$keycloak_db_username"
    export keycloak_db_password="$keycloak_db_password"

    export keycloak_db_username_b64=$(echo -ne $keycloak_db_username | base64)
    export keycloak_db_password_b64=$(echo -ne $keycloak_db_password | base64)
    export keycloak_db_b64=$(echo -ne $keycloak_db | base64)

    ## Create a enviroment variable for what we will be calling our keyclaok realm
    keycloak_realm="data_lake"
    export keycloak_realm="$keycloak_realm"

    #### Create our password/username for our secrests
    default_username="admin"
    default_password="admin"
    default_email="admin@admin.com"

    export postgres_root_username_b64=$(echo -ne $default_username | base64)
    export postgres_root_password_b64=$(echo -ne $default_password | base64)
    ## FIX-ME
#    export postgres_local_path="//run/desktop/mnt/host/c/Users/c.stone/Documents/GitHub/data_lake_example/postgres/data"
    export postgres_local_path="//run/desktop/mnt/host/c/Users/c.stone/Desktop/805_projects/data_lake_example/postgres/data"
#    export postgres_local_path="data_lake_example\postgres\data"
    export jupyter_local_path="//run/desktop/mnt/host/c/Users/c.stone/Desktop/805_projects/data_lake_example/jupyter/work"

    export pgadmin_root_username_b64=$(echo -ne $default_email | base64)
    export pgadmin_root_password_b64=$(echo -ne $default_password | base64)
    export keycloak_admin_username_b64=$(echo -ne $default_username | base64)
    export keycloak_admin_password_b64=$(echo -ne $default_password | base64)

    export _username=$(echo -ne $default_username | base64)
    export _password=$(echo -ne $default_password | base64)
#    echo $postgres_local_path

    # Save the CLIENT_SECRET, used for the KeyCloak and PgAdmin OAuth
    export CLIENT_SECRET=`tr -dc A-Za-z0-9 </dev/urandom | head -c 24 ; echo ''`
    
}
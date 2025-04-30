#!/bin/bash
set -m

kc_cmd="/opt/keycloak/bin/kc.sh";
kcadm_cmd="/opt/keycloak/bin/kcadm.sh";

## Start the keycloak server in the background
eval "${kc_cmd} start-dev &"

# Wait 
sleep 15s

exit_loop=0
declare -i loop_count=0
while [ $exit_loop == 0 ]
do
    ## Authenticate our connection to the api of keycloak
    printf "========== Attempting to configure connection to enable creating realms and services\n"
    realm_result="$($kcadm_cmd config credentials --server http://localhost:8080 --realm master --user admin --password admin 2>&1 /dev/null)"

    ERR_MSG_1="WARN"
    ERR_MSG_2="ERROR"
    ERR_MSG_3="Failed"

    if [[ "$realm_result" == *"$ERR_MSG_1"* ]] || [[ "$realm_result" == *"$ERR_MSG_2"* ]] || [[ "$realm_result" == *"$ERR_MSG_3"* ]]; then
        loop_count=$loop_count+1
        printf "== FAILED to connect $loop_count times\n"
        if [ $loop_count -gt 15 ]; then
            exit_loop=true
        fi

        sleep 15s
    else
        exit_loop=true

        ## Check and see if we already have a data_lake realm
        realm_check="$($kcadm_cmd get realms | grep data_lake)"
        printf "$realm_check \n"
        
        if [[ "$registry_status" =~ "data_lake" ]]; then
            printf "Realm already exist, skipping\n"
        else
            ## Create data_lake ream and the nifi client
            printf "========== - Creating data_lake realm\n"
            $kcadm_cmd create realms -s realm=data_lake -s enabled=true -o

            ## Adding your client for PgAdmin
            export CLIENT_SECRET="${CLIENT_SECRET}"
            $kc_cmd create clients -r data_lake -f clients/pgadmin.json
        fi

    fi
done

## Restore the keycloak server to the foreground
fg 1
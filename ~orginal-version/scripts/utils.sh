## Wait for a certain number of seconds, adding a "." every second
function pause_script {
    if [ -z "$1" ]; then
        ## Do nothing if no arguments are passed
        printf "ERROR: No arguments passed to 'pause_script', must be used something like 'pause_script 15'\n"
    else
        duration=$1
        while [ $duration -gt 0 ]; do
            printf "."
            sleep 1s
            duration=$(($duration-1))
        done
        printf "\n"
    fi
}

## Print / display the status of the current kubectl status
function get_status {
    $kubectl get all -n stone-data-lake
    printf "\n"
    $kubectl get persistentvolume -n stone-data-lake
    printf "\n"
    $kubectl get persistentvolumeclaim -n stone-data-lake
}

## Print horizontal rule (composed of '=')
function horizontal_seperator {
    printf "\n=============================================================================\n$1\n"
}
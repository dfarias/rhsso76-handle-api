#!/bin/bash

if [ ! -d "results" ]; then
    mkdir results
fi

getValue(){
    key=$1
    json=$2
    echo $(jq -r ".${key}" <<< $json)
}

callRest(){
    local method=$1
    local context=$2
    local payload=$3

    local url="$BASE_URL/admin/realms/$REALM_NAME/$context"

    callRestWithURL $method $url $payload
}

callRestWithURL(){
    local method=$1
    local url=$2
    local payload=$3

    curl -s -H "Accept: application/json, text/plain, */*" \
       -H "Content-Type: application/json;charset=UTF-8" \
       -H "$HEADER" -d $payload -X $method "$url"
}

callRestGetLocation(){
    local method=$1
    local context=$2
    local payload=$3
    local url="$BASE_URL/admin/realms/$REALM_NAME/$context"
    local location=$(curl -s -i -H "Accept: application/json, text/plain, */*" \
       -H "Content-Type: application/json;charset=UTF-8" \
       -H "$HEADER" \
       -d ${payload} \
       -X $method "$url" | grep -oP 'Location: \K.*' | tr -d '\r')

    echo "{\"url\":\"$location\",\"id\":\"$(echo $location | sed 's:.*/::')\"}"
}
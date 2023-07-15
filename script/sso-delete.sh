#!/bin/bash

deleteByContext(){
    local context=$1
    local url="$BASE_URL/admin/realms/$REALM_NAME/$context"
    curl -s -H "Accept: application/json, text/plain, */*" \
       -H "Content-Type: application/json;charset=UTF-8" \
       -H "$HEADER" -X DELETE $url
}

deleteClient(){
    local id=$1
    local context="clients/$id"
    deleteByContext $context
}

deleteClientScope(){
    local id=$1
    local context="client-scopes/$id"
    deleteByContext $context
}
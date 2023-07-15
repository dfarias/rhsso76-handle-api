#!/bin/bash

createRealm(){
    REALM_NAME=$1
    local url="$BASE_URL/admin/realms"
    local payload="{\"enabled\":true,\"id\":\"${REALM_NAME}\",\"realm\":\"${REALM_NAME}\"}"
    callRestWithURL POST $url $payload
}

# Criar role em um client.
# $1 Id do client
# $2 Nome da Role a ser criada
createClientRoles(){
    local clientId=$1
    local roleName=$2
    local payload="{\"name\":\"$roleName\"}"
    local location=$(callRestGetLocation POST "clients/$clientId/roles" $payload)
}

# Criar client scope.
# $1 Nome do client scope
createClientScope(){
    local name=$1
    local payload="{\"attributes\":{\"display.on.consent.screen\":false,\"include.in.token.scope\":false},\"name\":\"$name\",\"protocol\":\"openid-connect\"}"
    local location=$(callRestGetLocation POST "client-scopes" $payload)

    if $DEBUG ; then
        echo
        echo ">>>> createClientScope()"
        echo "name: $name"
        echo "payload: $payload1"
        echo "location: $location" 
        echo "<<<< createClientScope()"
        echo
    fi
}

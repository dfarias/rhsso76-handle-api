#!/bin/bash

declare -r BASE_URL=http://localhost:8081/auth
declare -r REALM_NAME=cliente

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
    echo ">>> URL: ${url} <<<"
    echo ">>> Payload: ${payload} <<<"
}

createUser(){
    local user_name=$1
    local user_id=1234567999876543-234565432-765432
    callRest POST "users/${user_id}/reset-password" "{\"type\":\"password\",\"value\":\"$user_name\",\"temporary\":false}"
}

createUser schimidt
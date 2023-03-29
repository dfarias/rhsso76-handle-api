#!/bin/bash

HEADER=
declare -r USERNAME=admin # SSO username
declare -r PASSWORD=admin # SSO password
declare -r BASE_URL=http://localhost:8080/auth
declare -r REALM_NAME=master
declare -r CLIENT_NAME=cliente
declare -r AUTH_TOKEN=$(echo -n "${CLIENT_NAME}:" | base64)

if [ ! -d "results" ]; then
    mkdir results
fi

obterToken(){
    local token=$(curl -d "grant_type=password&username=$USERNAME&password=$PASSWORD" -H "Authorization: Basic ${AUTH_TOKEN}" -X POST ${BASE_URL}/realms/${REALM_NAME}/protocol/openid-connect/token | jq .access_token | sed 's#\"##g');
    HEADER=$(echo Authorization: Bearer $token);
}

getClients(){
    curl -s -H "Accept: application/json, text/plain, */*" \
         -H "Content-Type: application/json;charset=UTF-8" \
         -H "$HEADER" \
         -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/clients" | jq '.[] | .id' | sed 's#"##g' > results/get-clients.json
}

getClientScopes(){
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/client-scopes" | jq '.[] | .id' | sed 's#"##g' > results/get-client-scopes.json
}

getDefaultOptionalClientScopes(){
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/default-optional-client-scopes" | jq '.[] | .id' | sed 's#"##g' > results/get-default-optional-client-scopes.json
}

getDefaultDefaultClientScopes(){
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/default-default-client-scopes" | jq '.[] | .id' | sed 's#"##g'> results/get-default-default-client-scopes.json
}

putDefaultOptionalClientScopes(){
    local client_scope_id=$1
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X PUT "${BASE_URL}/admin/realms/${REALM_NAME}/default-optional-client-scopes/${client_scope_id}"
}

obterToken
getClients
getClientScopes
getDefaultOptionalClientScopes
getDefaultDefaultClientScopes

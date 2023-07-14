#!/bin/bash

# Obter lista de clients
getClientsByQuery(){
  local clientId="${1}"
  local url="$BASE_URL/admin/realms/$REALM_NAME/clients?clientId=$clientId&search=true"
  echo ">>>> $url"
  curl -s -H "Accept: application/json, text/plain, */*" \
       -H "Content-Type: application/json;charset=UTF-8" \
       -H "$HEADER" \
       -X GET $url | jq '[.[] | { id, clientId }]' | jq -c '.[]' > results/get-clients.json
}

# Obter lista de client scopes
getClientScopes(){
    local url="$BASE_URL/admin/realms/$REALM_NAME/client-scopes"
    # echo ">>>> $url"
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET $url | jq '[.[] | { id, name }]' | jq -c '.[]' > results/get-client-scopes.json
}

# Obter lista de default optional client scopes
getDefaultOptionalClientScopes(){
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/default-optional-client-scopes" | jq '[.[] | { id, name }]' | jq -c '.[]' > results/get-default-optional-client-scopes.json
}

# Obter lista de default client scopes
getDefaultDefaultClientScopes(){
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/default-default-client-scopes" | jq '[.[] | { id, name }]' | jq -c '.[]' > results/get-default-default-client-scopes.json
}

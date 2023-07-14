#!/bin/bash

# Adicionar um client scope na lista de default optional client scope.
# $1 Id do client scope
putDefaultOptionalClientScopes(){
  local client_scope_id=$1
  curl -s -H "Accept: application/json, text/plain, */*" \
       -H "Content-Type: application/json;charset=UTF-8" \
       -H "$HEADER" \
       -X PUT "${BASE_URL}/admin/realms/${REALM_NAME}/default-optional-client-scopes/${client_scope_id}"
}

#
# $1 
resetUserPassword(){
    local password=$1
    local payload="{\"type\":\"password\",\"value\":\"$password\",\"temporary\":false}"
    callRestWithURL PUT "${url}/reset-password" $payload
}
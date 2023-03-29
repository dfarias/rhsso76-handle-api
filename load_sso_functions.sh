#!/bin/bash

# EXEMPLO
# jq '.result[] | {name,type,plan: .plan | {name,id}}' some-json-file
# {
#   "name": "somewebsite.com",
#   "type": "secondary",
#   "plan": {
#     "name": "Enterprise Website",
#     "id": "77777777777777777777777777"
#   }
# }

# Global Variables

# declare option variablename
# option could be:
#   -r read only variable
#   -i integer variable
#   -a array variable
#   -f for funtions
#   -x declares and export to subsequent commands via the environment.

HEADER=
declare -r USERNAME=admin # SSO username
declare -r PASSWORD=admin # SSO password
declare -r BASE_URL=http://localhost:8080/auth
declare -r REALM_NAME=master
declare -r CLIENT_NAME=cliente
declare -r AUTH_TOKEN=$(echo -n "${CLIENT_NAME}:" | base64)

if [ ! -d "results" ]; then
    mkdir results
else
    echo "..."
fi

# Arguments:
# $1 env variable name to check
# $2 default value if environment variable was not set
find_env() {
  var=${!1}
  echo "${var:-$2}"
}

## for file in $(ls Citinova-users-*.json); do 
##  filename=$(echo $file | sed 's#.json##g')
obterToken(){
    local token=$(curl -d "grant_type=password&username=$USERNAME&password=$PASSWORD" -H "Authorization: Basic ${AUTH_TOKEN}" -X POST ${BASE_URL}/realms/${REALM_NAME}/protocol/openid-connect/token | jq .access_token | sed 's#\"##g');
    HEADER=$(echo Authorization: Bearer $token);
    # curl -s -d @$file \
    #      -H "Accept: application/json, text/plain, */*" \
    #      -H "Content-Type: application/json;charset=UTF-8" \
    #      -H "$header" \
    #      -X POST "https://sso-rhsso-hom.apps.np-ocp.fortaleza.ce.gov.br/auth/admin/realms/novoRealm/partialImport"  > results/import-$file-result.out
}

getClients(){
    curl -s -H "Accept: application/json, text/plain, */*" \
         -H "Content-Type: application/json;charset=UTF-8" \
         -H "$HEADER" \
         -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/clients" | jq '.[] | .id' | sed 's#"##g' > results/get-clients.json
}

getClientScopes(){
    # local client_id=$1
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/client-scopes" | jq '.[] | .id' | sed 's#"##g' > results/get-client-scopes.json
}

# Arguments:
# $1 - client_id
getDefaultOptionalClientScopes(){
    # local client_id=$1
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/default-optional-client-scopes" | jq '.[] | .id' | sed 's#"##g' > results/get-default-optional-client-scopes.json
}

getDefaultDefaultClientScopes(){
    # local client_id=$1
    curl -s -H "Accept: application/json, text/plain, */*" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X GET "${BASE_URL}/admin/realms/${REALM_NAME}/default-default-client-scopes" | jq '.[] | .id' | sed 's#"##g'> results/get-default-default-client-scopes.json
}

putDefaultOptionalClientScopes(){
    local client_scope_id=$1
    local payload={"realm":"${REALM_NAME}","clientScopeId":"${client_scope_id}"}
    curl -s -H "Accept: application/json, text/plain, */*" \
    -d "${payload}" \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "$HEADER" \
    -X PUT "${BASE_URL}/admin/realms/${REALM_NAME}/default-optional-client-scopes/${client_scope_id}"
}

obterToken
getClients
getClientScopes
getDefaultOptionalClientScopes
getDefaultDefaultClientScopes
# putDefaultOptionalClientScopes cdb83ff5-135c-4483-806d-f07542f37612 #id de firmas-e-poderes-web

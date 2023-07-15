#!/bin/bash

HEADER=
REALM_NAME=cliente

declare -r DEBUG=false
declare -r USERNAME=admin # SSO username
declare -r PASSWORD=admin # SSO password
declare -r BASE_URL=http://localhost:8081/auth
#declare -r AUTH_TOKEN=$(echo -n "client" | base64)

source ./sso-common.sh
source ./sso-get.sh
source ./sso-post.sh
source ./sso-put.sh
source ./sso-delete.sh

obterToken(){
  local token=$(curl -d "grant_type=password&username=$USERNAME&password=$PASSWORD&client_id=admin-cli" -X POST $BASE_URL/realms/master/protocol/openid-connect/token | jq .access_token | sed 's#\"##g');
  HEADER=$(echo Authorization: Bearer $token);

  if $DEBUG ; then
    echo
    echo ">>>>> obterToken()"
    echo "token: $HEADER"
    echo "<<<<< obterToken()"
    echo
  fi
}



createClient(){
    local clientName=$1
    local location=$(callRestGetLocation POST clients "{\"enabled\":true,\"attributes\":{},\"redirectUris\":[],\"clientId\":\"${clientName}\",\"protocol\":\"openid-connect\"}")
    local clientId=$(getValue id $location)
    local url=$(getValue url $location)
    local payload="{\"id\":\"$clientId\",\"clientId\":\"$clientName\",\"surrogateAuthRequired\":false,\"enabled\":true,\"alwaysDisplayInConsole\":false,\"clientAuthenticatorType\":\"client-secret\",\"redirectUris\":[\"*\"],\"webOrigins\":[\"*\"],\"notBefore\":0,\"bearerOnly\":false,\"consentRequired\":false,\"standardFlowEnabled\":true,\"implicitFlowEnabled\":false,\"directAccessGrantsEnabled\":true,\"serviceAccountsEnabled\":false,\"publicClient\":true,\"frontchannelLogout\":false,\"protocol\":\"openid-connect\",\"attributes\":{\"backchannel.logout.session.required\":\"true\",\"backchannel.logout.revoke.offline.tokens\":\"false\",\"request.uris\":null,\"frontchannel.logout.url\":null,\"default.acr.values\":null,\"saml.artifact.binding\":\"false\",\"saml.server.signature\":\"false\",\"saml.server.signature.keyinfo.ext\":\"false\",\"saml.assertion.signature\":\"false\",\"saml.client.signature\":\"false\",\"saml.encrypt\":\"false\",\"saml.authnstatement\":\"false\",\"saml.onetimeuse.condition\":\"false\",\"saml_force_name_id_format\":\"false\",\"saml.allow.ecp.flow\":\"false\",\"saml.multivalued.roles\":\"false\",\"saml.force.post.binding\":\"false\",\"exclude.session.state.from.auth.response\":\"false\",\"oauth2.device.authorization.grant.enabled\":\"false\",\"oidc.ciba.grant.enabled\":\"false\",\"use.refresh.tokens\":\"true\",\"id.token.as.detached.signature\":\"false\",\"tls.client.certificate.bound.access.tokens\":\"false\",\"require.pushed.authorization.requests\":\"false\",\"client_credentials.use_refresh_token\":\"false\",\"token.response.type.bearer.lower-case\":\"false\",\"display.on.consent.screen\":\"false\",\"frontchannel.logout.session.required\":\"false\",\"acr.loa.map\":\"{}\",\"oauth2.device.polling.interval\":null},\"authenticationFlowBindingOverrides\":{},\"fullScopeAllowed\":false,\"nodeReRegistrationTimeout\":-1,\"defaultClientScopes\":[\"web-origins\",\"acr\",\"profile\",\"roles\",\"email\"],\"optionalClientScopes\":[\"address\",\"phone\",\"offline_access\",\"microprofile-jwt\"],\"access\":{\"view\":true,\"configure\":true,\"manage\":true},\"authorizationServicesEnabled\":\"\"}"

    if $DEBUG ; then
        echo
        echo ">>>> createClient()"
        echo "location: $location"
        echo "clientName: $clientName"
        echo "clientId: $clientId"
        echo "url: $url"
        echo "payload: $payload"
        echo "<<<< createClient()"
        echo
    fi

    callRestWithURL PUT $url $payload
    createClientRoles $clientId ROLE_A
}

createUser(){
    local name=$1
    local payload="{\"enabled\":true,\"attributes\":{},\"groups\":[],\"username\":\"$name\",\"emailVerified\":true,\"email\":\"\",\"firstName\":\"\",\"lastName\":\"\"}"
    local location=$(callRestGetLocation POST "users" $payload)
    local url=$(getValue url $location)

    resetUserPassword $name $url
}

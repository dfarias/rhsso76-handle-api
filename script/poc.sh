#!/bin/bash

source ./sso.sh

# Chamadas das funções do SSO.

# createUser user-1

createClientsAndClientScopes(){
    local values=("web" "sec" "api")
    for value in ${values[@]}; do
    # for value in {001..400}
    # do
        name="application-$value"
        echo $name
        createClient $name
        createClientScope $name
    done
}

removeClients(){
    items=$(cat ./results/get-clients.json | jq -c '.')

    for item in ${items[@]}; do
        id=$(getValue id $item)
        deleteClient $id
    done
}

removeClientScopes(){
    items=$(cat ./results/get-client-scopes.json | jq -c '.')

    for item in ${items[@]}; do
        id=$(getValue id $item)
        name=$(getValue name $item)
        if [[ $name == application* ]] ; then
            echo ">>> id=$id || name=$name"
            deleteClientScope $id
        fi
    done
}

obterToken
# createRealm cliente
createClientsAndClientScopes
getClientsByQuery
getClientScopes
# removeClients
# removeClientScopes
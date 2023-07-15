#!/bin/bash

declare -r ARQUIVO=./results/get-client-scopes.json
declare -r FILE_SCOPE_TO_ADD=./results/scope_to_add.json

source ./load_sso_functions.sh

cp ${ARQUIVO} ${FILE_SCOPE_TO_ADD}

filter_client_scopes(){
  local find_id=$1
  sed -i "/${id}/d" ${FILE_SCOPE_TO_ADD}
}

removeDefaultDefaultClientScopesFromClientScopes(){
  items=$(cat ./results/get-default-default-client-scopes.json | jq -c '.[]')

  for item in ${items[@]}; do
    id=$(jq -r '.id' <<< "$item")
    filter_client_scopes $id
  done
}

removeDefaultOptionalClientScopesFromClientScopes(){
  items=$(cat ./results/get-default-optional-client-scopes.json | jq -c '.[]')
  for item in ${items[@]}; do
    id=$(jq -r '.id' <<< "$item")
    filter_client_scopes $id
  done
}

removeDefaultDefaultClientScopesFromClientScopes
removeDefaultOptionalClientScopesFromClientScopes

if [ ! -s $FILE_SCOPE_TO_ADD ]; then
  echo "Não existe \"client scope\" para ser adicionado como opcional."
  exit 1
else
  echo
  echo "Adicionando \"client scopes\" como opcionais..."
  echo
fi

addClientScopesIntoDefaultOptionalScopes(){
  items=$(cat $FILE_SCOPE_TO_ADD | jq -c '.[]')
  echo $items
  for item in ${items[@]}; do
    id=$(jq -r '.id' <<< "$item")
    putDefaultOptionalClientScopes $id
  done
}

# addClientScopesIntoDefaultOptionalScopes

# Adiciona "client scope" na lista de "default optional scopes".
# while read client_scope_id; do
#   echo "Adding client_scope_id ${client_scope_id} to default_optional list."
#   putDefaultOptionalClientScopes $client_scope_id
# done < $FILE_SCOPE_TO_ADD

# items=$(cat ./results/get-clients.json | jq -c '.[]')
# for item in ${items[@]}; do
#   id=$(jq -r '.id' <<< "$item")
#   clientName=$(jq -r '.clientId' <<< "$item")
#   echo "The id is $id and client name is $clientName."
# done

# COUNT=$(cat ./results/get-clients.json | jq '. | length')
# echo ">>> $COUNT <<<"
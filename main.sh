#!/bin/bash

ARQUIVO=$1
declare -r FILE_SCOPE_TO_ADD=./results/scope_to_add.json

source ./get_clients.sh

cp ${ARQUIVO} ${FILE_SCOPE_TO_ADD}

filter_client_scopes(){
  local find_id=$1

  while read id; do
    if [ "${find_id}" == "${id}" ]; then
      echo "remove id ${id}"
      ex +g/$id/d -cwq ${FILE_SCOPE_TO_ADD}
    fi
  done < $ARQUIVO
}

# Remove "default client scopes" da lista de "client scopes"
while read id_add; do
  filter_client_scopes $id_add
done < results/get-default-default-client-scopes.json

# Remove "optional client scopes" da lista de "client scopes"
while read id_add; do
  filter_client_scopes $id_add
done < results/get-default-optional-client-scopes.json

if [ ! -s $FILE_SCOPE_TO_ADD ]; then
  echo "Não existe \"client scope\" para ser adicionado como opcional."
  exit 1
fi

echo
echo "Adicionando \"client scopes\" como opcionais..."
echo

# Adiciona "client scope" na lista de "default optional scopes".
while read client_scope_id; do
  echo "Adding client_scope_id ${client_scope_id} to default_optional list."
  putDefaultOptionalClientScopes $client_scope_id
done < $FILE_SCOPE_TO_ADD

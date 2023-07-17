#!/bin/bash

# POSTGRES
NETWORK=$(podman network ls 2>/dev/null | grep sso | wc -l)
if [ "$NETWORK" = "0" ]; then
  podman network create sso
fi

DB_VOLUME=$(podman volume ls 2>/dev/null | grep sso_data | wc -l)
if [ "$DB_VOLUME" = "0" ]; then
  podman volume create sso_data
fi

podman run --env-file=.env \
    --network sso \
    --name postgres \
    -p 5432:5432 \
    -v sso_data:/var/lib/pgsql/data \
    -d registry.redhat.io/rhel8/postgresql-13:latest

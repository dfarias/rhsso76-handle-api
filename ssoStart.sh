#!/bin/bash

podman run -rm --env-file=.env \
    --network sso \
    --name rhsso \
    -p 8080:8080 \
    -p 8443:8443 \
    -p 8778:8778 \
    -d registry.redhat.io/rh-sso-7/sso76-openshift-rhel8:latest

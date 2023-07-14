https://raw.githubusercontent.com/jboss-container-images/redhat-sso-7-openshift-image/sso76-dev/templates/passthrough/sso76-postgresql-persistent.json

POSTGRESQL_USER
POSTGRESQL_PASSWORD
POSTGRESQL_DATABASE
POSTGRESQL_MAX_CONNECTIONS
POSTGRESQL_MAX_PREPARED_TRANSACTIONS
POSTGRESQL_SHARED_BUFFERS

---

podman pull registry.redhat.io/rhel8/postgresql-10:latest
podman pull registry.redhat.io/rh-sso-7/sso76-openshift-rhel8:latest

---

podman pod create --name sso-pod \
       -p 8080:8080 \
       -p 5432:5432

---

podman run \
  --pod sso-pod \
  --name=sso-postgres \
  --restart=always \
  -e POSTGRES_PASSWORD=keycloak \
  -e POSTGRES_USER=admin \
  -e POSTGRES_DB=keycloak\
  -d postgresql-10:latest

---

podman run \
  --pod sso-pod \
  --name rhsso76 \
  --restart=always \
  -p 8080:8080 \
  -e SSO_ADMIN_PASSWORD=admin \
  -e SSO_ADMIN_USERNAME=admin \
  -e JAVA_OPTS_APPEND="-Dkeycloak.profile.feature.scripts=enabled -Dkeycloak.profile.feature.upload_scripts=enabled -Dkeycloak.profile=preview" \
  -d sso76-openshift-rhel8:latest

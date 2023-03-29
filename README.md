# How can I start RHSSO 7.6

1. Login into Red Hat registry
   ```
   podman login registry.redhat.io
   ```
1. Downloading the image
   ```
   podman pull registry.redhat.io/rh-sso-7/sso76-openshift-rhel8:7.6
   ```
1. Building a custom imagem (if you need)
   ```
   podman build -f Containerfile.sso -t rh-sso76
   ```
1. Running using `podman`
   ```
   podman run --name rhsso2 \
       -p 8180:8080 \
       -e SSO_ADMIN_PASSWORD=admin \
       -e SSO_ADMIN_USERNAME=admin \
       -e JAVA_OPTS_APPEND="-Dkeycloak.profile.feature.scripts=enabled -Dkeycloak.profile.feature.upload_scripts=enabled" \
       -d rh-sso76
   ```
# How can I start Database and RHSSO 7.6

1. Login into Red Hat registry
   ```
   podman login registry.redhat.io
   ```
1. Downloading the images
   ```
   podman pull registry.redhat.io/rhel8/postgresql-13:latest
   podman pull registry.redhat.io/rh-sso-7/sso76-openshift-rhel8:latest
   ```
1. Building a custom RHSSO imagem (if you need)
   ```
   podman build -f Containerfile.sso -t rh-sso76
   ```
1. Running using `podman`
   ```
   ./dbStart.sh
   ./ssoStart.sh
   ```

   > IMPORTANT
   >
   > Every time that you stop de RHSSO, you'll need to recreate then (only rhsso).

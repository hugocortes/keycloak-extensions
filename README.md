# keycloak-extensions
Extensions for Keycloak: https://github.com/keycloak/keycloak

## Running locally
```sh
# init git submodule
git submodulke init
git submodule update

# build locally
cd keycloak-sources && mvn clean install -Pdistribution -DskipTests && cd ../

# untar 
tar xfz keycloak-source/distribution/server-dist/target/keycloak-4.8.3.Final.tar.gz

# package extensions
cd extensions && mvn clean install && cd ../

# add modules to keycloak standalone
<providers>
    <provider>classpath:${jboss.home.dir}/providers/*</provider>
    <provider>module:me.hugocortes.actions.analytics</provider>
</providers>

# add modules jboss-cli
./keycloak-4.8.3.Final/bin/jboss-cli.sh --command="module add --name=me.hugocortes.actions.analytics --dependencies=org.keycloak.keycloak-core,org.keycloak.keycloak-server-spi,org.keycloak.keycloak-server-spi-private --resources=extensions/actions/target/actions-4.8.3.Final.jar"

# run keycloak with standalone (relative to keycloak-4.8.3.Final/standalone/configuration)
./keycloak-4.8.3.Final/bin/standalone.sh -c ./../../../standalone-4.8.3.xml
```

## Docker

The docker setup was based off of [jboss-dockerfiles/keycloak](https://github.com/jboss-dockerfiles/keycloak/tree/master/server). Additional steps were added to add custom extension support.

To build: `docker build -t <repo>/<name>:<tag> .`
To push: `docker push <repo>/<name>`

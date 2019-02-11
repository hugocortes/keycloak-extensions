#!/bin/bash -e

#####################
# Create DB modules #
#####################

mkdir -p /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
cd /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
curl -L http://central.maven.org/maven2/org/postgresql/postgresql/$JDBC_POSTGRES_VERSION/postgresql-$JDBC_POSTGRES_VERSION.jar > postgres-jdbc.jar
cp /opt/jboss/tools/databases/postgres/module.xml .

######################
# Configure Keycloak #
######################

cd /opt/jboss/keycloak

bin/jboss-cli.sh --command="module add --name=me.hugocortes.actions.analytics --dependencies=org.keycloak.keycloak-core,org.keycloak.keycloak-server-spi,org.keycloak.keycloak-server-spi-private --resources=/opt/jboss/extensions/actions-4.8.3.Final.jar"

bin/jboss-cli.sh --file=/opt/jboss/tools/cli/standalone-configuration.cli
rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history

bin/jboss-cli.sh --file=/opt/jboss/tools/cli/standalone-ha-configuration.cli
rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history

###################
# Set permissions #
###################

chown -R jboss:0 /opt/jboss/keycloak
chmod -R g+rw /opt/jboss/keycloak

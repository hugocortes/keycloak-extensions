#!/bin/bash

##########################
# Configure Extensions #
##########################
KEYCLOAK_BUILD_DIR=$1

KEYCLOAK_BUILD_DIR=${KEYCLOAK_BUILD_DIR:=/opt/jboss/keycloak}

TEMP_DIR=/tmp/keycloak
EXTENSION_DIR=$TEMP_DIR/extensions
THEMES_DIR=$TEMP_DIR/themes

cd $KEYCLOAK_BUILD_DIR

# copy themes
cp -R $THEMES_DIR/* $KEYCLOAK_BUILD_DIR/themes

bin/jboss-cli.sh --command="module add \
  --name=keycloak-extensions-analytics \
  --dependencies=org.keycloak.keycloak-core,org.keycloak.keycloak-server-spi,org.keycloak.keycloak-server-spi-private \
  --resources=$EXTENSION_DIR/keycloak-extensions-analytics-$KEYCLOAK_VERSION.jar"

bin/jboss-cli.sh --file=$TEMP_DIR/extensions.cli
rm -rf standalone/configuration/standalone_xml_history

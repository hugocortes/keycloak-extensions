#!/bin/bash

##########################
# Configure Keycloak CLI #
##########################
KEYCLOAK_BUILD_DIR=$1

KEYCLOAK_BUILD_DIR=${KEYCLOAK_BUILD_DIR:=/opt/jboss/keycloak}

TEMP_DIR=/tmp

cd $KEYCLOAK_BUILD_DIR
bin/jboss-cli.sh --file=$TEMP_DIR/standalone-configuration.cli
rm -rf $KEYCLOAK_BUILD_DIR/standalone/configuration/standalone_xml_history

bin/jboss-cli.sh --file=$TEMP_DIR/standalone-ha-configuration.cli
rm -rf $KEYCLOAK_BUILD_DIR/standalone/configuration/standalone_xml_history

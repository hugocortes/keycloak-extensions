#!/bin/bash

############################
# git submodule initialize #
############################
git submodule init
git submodule update

############
# set args #
############
while getopts "e:" OPTION
do
  case $OPTION in
    e)
      KEY=$(cut -d '=' -f 1 <<< $OPTARG)
      VALUE=$(cut -d '=' -f 2 <<< $OPTARG)
      export $KEY=$VALUE
      echo "setting variables: $KEY"
      ;;
    \?)
      echo "Usage: cmd [-e]"
      ;;
  esac
done

sleep 1s

######################
# set default values #
######################
export KEYCLOAK_VERSION=4.8.3.Final
export JDBC_POSTGRES_VERSION=${JDBC_POSTGRES_VERSION:-"42.2.2"}
export JDBC_MYSQL_VERSION=${JDBC_MYSQL_VERSION:-"5.1.47"}
export JDBC_MARIADB_VERSION=${JDBC_MARIADB_VERSION:-"2.2.3"}

REPO_DIR=$(pwd)
KEYCLOAK_SRC_DIR=$REPO_DIR/keycloak-source
KEYCLOAK_BUILD_DIR=$REPO_DIR/keycloak-$KEYCLOAK_VERSION
KEYCLOAK_CLI_DIR=$REPO_DIR/Docker/cli
KEYCLOAK_TOOLS_DIR=$REPO_DIR/Docker
KEYCLOAK_EXTENSION_DIR=$REPO_DIR/extensions
KEYCLOAK_THEMES_DIR=$REPO_DIR/themes
TEMP_DIR=/tmp/keycloak
rm -rf /tmp/keycloak
mkdir /tmp/keycloak

DB_VENDOR=${DB_VENDOR:-""}
USE_EXISTING_BUILD=${USE_EXISTING_BUILD:-""}

##############################
# setup required directories #
##############################
# copy tools
cp -R $KEYCLOAK_CLI_DIR/* $TEMP_DIR

# copy themes
mkdir -p $TEMP_DIR/themes
cp -R $KEYCLOAK_THEMES_DIR/* $TEMP_DIR/themes

# setup extension jar folder
mkdir -p $TEMP_DIR/extensions
rm -rf $TEMP_DIR/extensions/*.jar
rm -rf $TEMP_DIR/extensions/*.ear

#################################################
# mvn installation keycloak source + extensions #
#################################################
cd $KEYCLOAK_SRC_DIR
if [ "$USE_EXISTING_BUILD" != "true" ]; then
  mvn clean install -Pdistribution -DskipTests
fi
cd $REPO_DIR
rm -rf $KEYCLOAK_BUILD_DIR
tar xfz $KEYCLOAK_SRC_DIR/distribution/server-dist/target/keycloak-*.tar.gz

cd $KEYCLOAK_EXTENSION_DIR
mvn clean install
# cp $KEYCLOAK_EXTENSION_DIR/**/target/*.jar $TEMP_DIR/extensions
cp $KEYCLOAK_EXTENSION_DIR/**/**/target/*.ear $TEMP_DIR/extensions

##############################
# Keycloak cli configuration #
##############################
# get db module deps
/bin/sh $KEYCLOAK_TOOLS_DIR/configure-db.sh $KEYCLOAK_BUILD_DIR $KEYCLOAK_TOOLS_DIR

# initialize standalone configs
/bin/sh $KEYCLOAK_TOOLS_DIR/configure-cli.sh $KEYCLOAK_BUILD_DIR

# configure extensions and themes
/bin/sh $KEYCLOAK_TOOLS_DIR/configure-extensions.sh $KEYCLOAK_BUILD_DIR

#####################################
# Keycloak pre-launch configuration #
#####################################
# change database
/bin/sh $KEYCLOAK_TOOLS_DIR/databases/change-database.sh "$DB_VENDOR" $KEYCLOAK_BUILD_DIR $KEYCLOAK_TOOLS_DIR

# jgroups
$KEYCLOAK_TOOLS_DIR/jgroups.sh $JGROUPS_DISCOVERY_PROTOCOL $JGROUPS_DISCOVERY_PROPERTIES

###################
# Launch Keycloak #
###################
$KEYCLOAK_BUILD_DIR/bin/standalone.sh --debug \
  -Denv.DB_VENDOR=$DB_VENDOR \
  -Denv.DB_ADDR=$DB_ADDR \
  -Denv.DB_PORT=$DB_PORT \
  -Denv.DB_DATABASE=$DB_DATABASE \
  -Denv.DB_USER=$DB_USER \
  -Denv.DB_PASSWORD=$DB_PASSWORD

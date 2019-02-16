#!/bin/bash -e

DB_VENDOR=$1

KEYCLOAK_BUILD_DIR=$2
KEYCLOAK_TOOLS_DIR=$3

KEYCLOAK_BUILD_DIR=${KEYCLOAK_BUILD_DIR:=/opt/jboss/keycloak}
KEYCLOAK_TOOLS_DIR=${KEYCLOAK_TOOLS_DIR:=/opt/jboss/tools}
KEYCLOAK_CLI_DIR=$KEYCLOAK_TOOLS_DIR/cli

TEMP_DIR=/tmp/keycloak

# Lower case DB_VENDOR
DB_VENDOR=`echo $DB_VENDOR | tr A-Z a-z`
# Detect DB vendor from legacy `*_ADDR` environment variables
if [ "$DB_VENDOR" == "" ]; then
    if (printenv | grep '^POSTGRES_ADDR=' &>/dev/null); then
        export DB_VENDOR="postgres"
    elif (printenv | grep '^MYSQL_ADDR=' &>/dev/null); then
        export DB_VENDOR="mysql"
    fi
fi

# Default to H2 if DB type not detected
if [ "$DB_VENDOR" == "" ]; then
    export DB_VENDOR="h2"
fi

# Set DB name
case "$DB_VENDOR" in
  postgres)
    DB_NAME="PostgreSQL"
    ;;
  mysql)
    DB_NAME="MySQL"
    ;;
  h2)
    DB_NAME="Embedded H2";;
  *)
    echo "Unknown DB vendor $DB_VENDOR"
    exit 1
esac

# Append '?' in the beggining of the string if JDBC_PARAMS value isn't empty
export JDBC_PARAMS=$(echo ${JDBC_PARAMS} | sed '/^$/! s/^/?/')

echo "========================================================================="
echo ""
echo "  Using $DB_NAME database"
echo ""
echo "========================================================================="
echo ""

if [ "$DB_VENDOR" != "h2" ]; then
  cp $KEYCLOAK_CLI_DIR/databases/$DB_VENDOR/change-database.cli $TEMP_DIR/databases/
  cd $KEYCLOAK_BUILD_DIR

  bin/jboss-cli.sh --file=$TEMP_DIR/databases/standalone-configuration.cli
  rm -rf standalone/configuration/standalone_xml_history

  bin/jboss-cli.sh --file=$TEMP_DIR/databases/standalone-ha-configuration.cli
  rm -rf standalone/configuration/standalone_xml_history/current/*
fi

#!/bin/bash

######################
# add all db modules #
######################
KEYCLOAK_BUILD_DIR=$1
KEYCLOAK_TOOLS_DIR=$2

KEYCLOAK_BUILD_DIR=${KEYCLOAK_BUILD_DIR:=/opt/jboss/keycloak}
KEYCLOAK_TOOLS_DIR=${KEYCLOAK_TOOLS_DIR:=/opt/jboss/tools}

mkdir -p $KEYCLOAK_BUILD_DIR/modules/system/layers/base/org/postgresql/jdbc/main
cd $KEYCLOAK_BUILD_DIR/modules/system/layers/base/org/postgresql/jdbc/main
curl -L http://central.maven.org/maven2/org/postgresql/postgresql/$JDBC_POSTGRES_VERSION/postgresql-$JDBC_POSTGRES_VERSION.jar > postgres-jdbc.jar
cp $KEYCLOAK_TOOLS_DIR/databases/postgres/module.xml .

mkdir -p $KEYCLOAK_BUILD_DIR/modules/system/layers/base/com/mysql/jdbc/main
cd $KEYCLOAK_BUILD_DIR/modules/system/layers/base/com/mysql/jdbc/main
curl -O http://central.maven.org/maven2/mysql/mysql-connector-java/$JDBC_MYSQL_VERSION/mysql-connector-java-$JDBC_MYSQL_VERSION.jar
cp $KEYCLOAK_TOOLS_DIR/databases/mysql/module.xml .

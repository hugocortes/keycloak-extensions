######################
# set default values #
######################
REPO_DIR=$(pwd)
KEYCLOAK_BUILD_DIR=$REPO_DIR/keycloak-build
KEYCLOAK_EXTENSION_DIR=$REPO_DIR/extensions

TEMP_DIR=/tmp/keycloak
EXTENSION_DIR=$TEMP_DIR/extensions

##############
# hot deploy #
##############
cd $KEYCLOAK_EXTENSION_DIR
mvn clean install
cp $KEYCLOAK_EXTENSION_DIR/**/**/target/*.ear $TEMP_DIR/extensions
cp $EXTENSION_DIR/analytics.ear $KEYCLOAK_BUILD_DIR/standalone/deployments

# rm -rf $KEYCLOAK_BUILD_DIR/themes/<name>
cp -R $REPO_DIR/themes/* $KEYCLOAK_BUILD_DIR/themes

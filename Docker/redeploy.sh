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
REPO_DIR=$(pwd)
KEYCLOAK_EXTENSION_DIR=$REPO_DIR/extensions
KEYCLOAK_BUILD_DIR=$REPO_DIR/keycloak-build

###################################################
# remove hot deployment themes and ear extensions #
###################################################
rm -rf $KEYCLOAK_BUILD_DIR/standalone/deployments/*.ear
cd $KEYCLOAK_EXTENSION_DIR
mvn clean install
cp $KEYCLOAK_EXTENSION_DIR/**/**/target/*.ear $KEYCLOAK_BUILD_DIR/standalone/deployments

rm -rf $KEYCLOAK_BUILD_DIR/themes/dashboard
cp -R $REPO_DIR/themes/* $KEYCLOAK_BUILD_DIR/themes

$KEYCLOAK_BUILD_DIR/bin/standalone.sh --debug \
  -Denv.DB_VENDOR=$DB_VENDOR \
  -Denv.DB_ADDR=$DB_ADDR \
  -Denv.DB_PORT=$DB_PORT \
  -Denv.DB_DATABASE=$DB_DATABASE \
  -Denv.DB_USER=$DB_USER \
  -Denv.DB_PASSWORD=$DB_PASSWORD

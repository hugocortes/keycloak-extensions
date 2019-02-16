#!/bin/bash

##################
# Add admin user #
##################

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    /opt/jboss/keycloak/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi

############
# Hostname #
############

if [ "$KEYCLOAK_HOSTNAME" != "" ]; then
    SYS_PROPS="-Dkeycloak.hostname.provider=fixed -Dkeycloak.hostname.fixed.hostname=$KEYCLOAK_HOSTNAME"

    if [ "$KEYCLOAK_HTTP_PORT" != "" ]; then
        SYS_PROPS+=" -Dkeycloak.hostname.fixed.httpPort=$KEYCLOAK_HTTP_PORT"
    fi

    if [ "$KEYCLOAK_HTTPS_PORT" != "" ]; then
        SYS_PROPS+=" -Dkeycloak.hostname.fixed.httpsPort=$KEYCLOAK_HTTPS_PORT"
    fi
fi

################
# Realm import #
################

if [ "$KEYCLOAK_IMPORT" ]; then
    SYS_PROPS+=" -Dkeycloak.import=$KEYCLOAK_IMPORT"
fi

########################
# JGroups bind options #
########################

if [ -z "$BIND" ]; then
    BIND=$(hostname -i)
fi
if [ -z "$BIND_OPTS" ]; then
    for BIND_IP in $BIND
    do
        BIND_OPTS+=" -Djboss.bind.address=$BIND_IP -Djboss.bind.address.private=$BIND_IP "
    done
fi
SYS_PROPS+=" $BIND_OPTS"

#################
# Configuration #
#################

# If the "-c" parameter is not present, append the HA profile.
if echo "$@" | egrep -v -- "-c "; then
    SYS_PROPS+=" -c standalone-ha.xml"
fi

############
# DB setup #
############
/opt/jboss/tools/databases/change-database.sh "$DB_VENDOR"

/opt/jboss/tools/x509.sh
/opt/jboss/tools/jgroups.sh $JGROUPS_DISCOVERY_PROTOCOL $JGROUPS_DISCOVERY_PROPERTIES

##################
# Start Keycloak #
##################

exec /opt/jboss/keycloak/bin/standalone.sh $SYS_PROPS $@
exit $?

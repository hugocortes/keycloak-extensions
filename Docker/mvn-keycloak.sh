#!/bin/bash -e

###########################
# Build/download Keycloak #
###########################

# Install Maven
cd /opt/jboss 
curl -s http://apache.uib.no/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar xz
mv apache-maven-3.5.4 /opt/jboss/maven
export M2_HOME=/opt/jboss/maven

# Build
cd /opt/jboss/keycloak-source

$M2_HOME/bin/mvn -q -Pdistribution -pl distribution/server-dist -am -Dmaven.test.skip clean install

cd /opt/jboss

tar xfz /opt/jboss/keycloak-source/distribution/server-dist/target/keycloak-*.tar.gz

mv /opt/jboss/keycloak-?.?.?.* /opt/jboss/keycloak

# replace standalones
rm /opt/jboss/keycloak/standalone/configuration/standalone.xml
rm /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml

mv /opt/jboss/standalone.xml /opt/jboss/keycloak/standalone/configuration/
mv /opt/jboss/standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/

# Build extensions
cd /opt/jboss/extensions-source
$M2_HOME/bin/mvn -q clean install
cd /opt/jboss
mkdir extensions
mv /opt/jboss/extensions-source/actions/target/actions-*.jar /opt/jboss/extensions/

# Remove temporary files
rm -rf /opt/jboss/maven
rm -rf /opt/jboss/keycloak-source
rm -rf /opt/jboss/extensions-source
rm -rf $HOME/.m2/repository

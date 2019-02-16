##################
# Build Keycloak #
##################
FROM maven:3.5-jdk-8 AS mvnKeycloak

ENV MAVEN_OPTS="-Xms1024m -Xmx2048m"

RUN mkdir -p /opt/jboss
WORKDIR /opt/jboss

COPY .git .git
COPY .gitmodules .
COPY keycloak-source keycloak-source
RUN git submodule init
RUN git submodule update

RUN cd keycloak-source && \
  mvn -q -Pdistribution -pl distribution/server-dist -am -Dmaven.test.skip clean install
RUN tar xfz keycloak-source/distribution/server-dist/target/keycloak-*.tar.gz
RUN mv keycloak-?.?.?.* keycloak

######################
# Configure Keycloak #
######################
FROM maven:3.5-jdk-8

RUN mkdir -p /opt/jboss/keycloak
COPY --from=mvnKeycloak /opt/jboss/keycloak /opt/jboss/keycloak

######################
# set default values #
######################
ENV KEYCLOAK_VERSION 4.8.3.Final
ENV JDBC_POSTGRES_VERSION 42.2.2
ENV JDBC_POSTGRES_VERSION 42.2.2
ENV JDBC_MYSQL_VERSION 5.1.47
ENV JDBC_MARIADB_VERSION 2.2.3

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

##############################
# setup required directories #
##############################
RUN mkdir -p /opt/jboss
RUN mkdir -p /tmp/keycloak
WORKDIR /opt/jboss

# copy tools
COPY Docker tools
RUN cp -r tools/cli/* /tmp/keycloak

# copy themes
COPY themes /tmp/keycloak/themes

# copy extension
COPY extensions extensions-source
RUN mkdir -p /tmp/keycloak/extensions

###################################
# mvn build keycloak + extensions #
###################################
ENV MAVEN_OPTS="-Xms1024m -Xmx2048m"

RUN cd extensions-source && mvn clean install && cd ../
RUN mv extensions-source/**/target/*.jar /tmp/keycloak/extensions
RUN rm -rf extensions-source

##############################
# Keycloak cli configuration #
##############################
# get db module deps
RUN /bin/sh /opt/jboss/tools/configure-db.sh

# initialize standalone configs
RUN /bin/sh /opt/jboss/tools/configure-cli.sh

# configure extensions and themes
RUN /bin/sh /opt/jboss/tools/configure-extensions.sh
RUN rm -rf /tmp/keycloak/extensions/*

RUN chown -R 1000:0 /opt/jboss/keycloak
RUN chown -R 1000:0 /tmp/keycloak
RUN chmod -R g+rw /opt/jboss/keycloak

###################
# Keycloak launch #
###################
EXPOSE 8080

USER 1000

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]

#############################
# mvn Keycloak Installation #
#############################

FROM jboss/base-jdk:8 AS mvn-keycloak

USER root
RUN yum install -y epel-release git && yum install -y jq openssl which && yum clean all

RUN mkdir -p /opt/jboss
WORKDIR /opt/jboss

COPY Docker/ tools

COPY .git/ .git
COPY .gitmodules .
COPY keycloak-source/ keycloak-source
RUN git submodule init
RUN git submodule update

COPY extensions/ extensions-source
COPY standalone-4.8.3.xml standalone.xml
COPY standalone-ha-4.8.3.xml standalone-ha.xml

RUN /opt/jboss/tools/mvn-keycloak.sh

#####################
# Docker Initialize #
#####################

FROM jboss/base-jdk:8

ENV KEYCLOAK_VERSION 4.6.0.Final
ENV JDBC_POSTGRES_VERSION 42.2.2
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

USER root

RUN yum install -y epel-release git && yum install -y jq openssl which && yum clean all

RUN mkdir -p /opt/jboss
COPY --from=mvn-keycloak /opt/jboss /opt/jboss

RUN /opt/jboss/tools/build-keycloak.sh

USER 1000

EXPOSE 8080

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]

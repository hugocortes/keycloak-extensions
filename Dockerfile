FROM jboss/keycloak:11.0.3 as keycloak

RUN mkdir -p /tmp
WORKDIR /opt/jboss
SHELL [ "/bin/bash", "-c" ]

# required env for docker ctx
ENV KEYCLOAK_VERSION 11.0.0
ENV JDBC_POSTGRES_VERSION 42.2.5
ENV JDBC_MYSQL_VERSION 8.0.22
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 8.2.2.jre11

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8
ENV MAVEN_OPTS -Xms1024m -Xmx2048m

ADD themes /opt/jboss/keycloak/themes

# default keycloak to run
USER 1000
EXPOSE 8080
EXPOSE 8443
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

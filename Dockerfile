FROM jboss/keycloak:14.0.0 as keycloak

ENV MAVEN_OPTS -Xms1024m -Xmx2048m
SHELL [ "/bin/bash", "-c" ]

WORKDIR /opt/jboss

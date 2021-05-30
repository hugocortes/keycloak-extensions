FROM jboss/keycloak:13.0.1 as keycloak

ENV MAVEN_OPTS -Xms1024m -Xmx2048m
SHELL [ "/bin/bash", "-c" ]

WORKDIR /opt/jboss

ADD themes keycloak/themes

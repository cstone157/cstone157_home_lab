# Our base Docker Image, usinging the quay.io.  The 
#    keycloak image uses micro RHEL image, but is so 
#    locked down that you can't install anything.
#FROM registry.access.redhat.com/ubi9 as ubi-micro-build
#FROM quay.io/keycloak/keycloak:24.0.2
#FROM keycloak/keycloak:24.0.2
FROM keycloak/keycloak:21.0.2

COPY /setup.sh   /opt/keycloak/setup.sh

# Copy all of our clients over to the 
RUN mkdir -p /opt/keycloak/clients
COPY ./clients/pgadmin.json   /opt/keycloak/clients/pgadmin.json


# Original entrypoint for keycloak
ENTRYPOINT ["/opt/keycloak/setup.sh"]

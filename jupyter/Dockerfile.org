FROM jupyter/minimal-notebook:x86_64-python-3.11.6

ARG OAUTH_AUTHORIZE_URL="https://keycloak:30000/auth/realms/${keycloak_realm}/protocol/openid-connect/auth"
ARG OAUTH_ACCESS_TOKEN_URL="https://keycloak:30000/auth/realms/${keycloak_realm}/protocol/openid-connect/token"
ARG CLIENT_ID="jupyter"
ARG CLIENT_SECRET="${CLIENT_SECRET}"
ARG USERDATA_URL="https://keycloak:30000/auth/realms/${keycloak_realm}/protocol/openid-connect/userinfo"
ARG TOKEN_URL="https://keycloak:30000/auth/realms/${keycloak_realm}/protocol/openid-connect/token"
ARG OAUTH_CALLBACK_URL="http://jupyter-notebook:30400/hub/oauth_callback"
ARG USERNAME_KEY="email"

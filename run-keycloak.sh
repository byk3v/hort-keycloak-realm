#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
KEYCLOAK_HOST_PORT=$(
  awk -F= '$1 == "KEYCLOAK_HOST_PORT" { print substr($0, index($0, "=") + 1) }' "$SCRIPT_DIR/.env"
)
: "${KEYCLOAK_HOST_PORT:=8180}"

podman run -d \
  --replace \
  --name keycloak \
  -p "${KEYCLOAK_HOST_PORT}:8080" \
  --env-file "$SCRIPT_DIR/.env" \
  -v "$SCRIPT_DIR:/opt/keycloak/data/import:ro" \
  -v "$SCRIPT_DIR/themes:/opt/keycloak/themes:ro" \
  quay.io/keycloak/keycloak:latest \
  start-dev --import-realm

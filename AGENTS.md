# HORT Keycloak Agent Guide

## Scope

This repository owns the HORT Keycloak realm export, clients, roles, token
configuration, local startup helper, and login theme. Read `../AGENTS.md` before
changing any identity contract.

## Identity contract rules

- Treat realm roles, client roles, audiences, claims, client IDs, redirect
  URIs, and web origins as an external contract.
- Coordinate identity-contract changes with Spring Security converters and
  authorization rules in `hort-backend`.
- Check affected web and mobile authentication configuration.
- Use separate public clients and appropriate redirect URIs for web and mobile
  when mobile authentication is introduced.
- Backend authorization remains mandatory even when UI navigation is hidden by
  role.

## Configuration and secrets

- Never commit passwords, tokens, private keys, or populated local `.env`
  files.
- Keep safe placeholders in the realm export and document required environment
  variables in `.env.example`.
- Pin the Keycloak container image to an explicit tested version; do not add new
  uses of `latest`.
- Avoid environment-specific hostnames in the canonical realm when they can be
  parameterized.

## Realm changes

- Prefer small, reviewable realm changes and normalize JSON formatting.
- Distinguish bootstrap/import behavior from updates to an existing realm.
- Do not assume re-importing a realm safely mutates production state.
- Role removal, client removal, credential changes, and redirect URI
  restrictions can disrupt users and require explicit approval and rollout
  planning.

## Theme changes

- Keep theme changes isolated from identity-contract changes when practical.
- Check that referenced parent themes, resources, and content types work with
  the pinned Keycloak version.

## Verification

For realm or authentication changes, start an isolated local Keycloak instance,
import the realm, obtain a test token through an approved test flow, inspect
expected claims, and run backend authorization smoke tests. Ask permission
before starting containers, changing external state, or using real credentials.

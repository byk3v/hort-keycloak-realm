# Hort Keycloak Realm

`Hort-realm.json` usa placeholders de variables de entorno para no guardar secretos dentro del export del realm.

Variables:

- `HORT_REALM_NAME`: nombre del realm que se importara.
- `HORT_ADMIN_PASSWORD`: password inicial del usuario `admin` dentro del realm.
- `HORT_LOGIN_THEME`: theme de login que usara el realm.
- `KEYCLOAK_ADMIN`: usuario admin bootstrap de Keycloak.
- `KEYCLOAK_ADMIN_PASSWORD`: password admin bootstrap de Keycloak.
- `KEYCLOAK_HOST_PORT`: puerto local donde se expone Keycloak.

Ejemplo con Podman:

```bash
./run-keycloak.sh
```

Comando equivalente:

```bash
KEYCLOAK_HOST_PORT=$(awk -F= '$1 == "KEYCLOAK_HOST_PORT" { print substr($0, index($0, "=") + 1) }' .env)

podman run -d \
  --replace \
  --name keycloak \
  -p "${KEYCLOAK_HOST_PORT:-8180}:8080" \
  --env-file .env \
  -v "$PWD:/opt/keycloak/data/import:ro" \
  -v "$PWD/themes:/opt/keycloak/themes:ro" \
  quay.io/keycloak/keycloak:latest \
  start-dev --import-realm
```

En Docker Compose o Hetzner, asegura que esas variables lleguen al contenedor de Keycloak. Keycloak resuelve los placeholders durante el import del realm.

## Theme de login

El theme esta en `themes/hort/login` y se monta dentro del contenedor en `/opt/keycloak/themes`.

Para ajustar estilos del login, edita:

```bash
themes/hort/login/resources/css/hort-login.css
```

Para que los cambios se vean en un realm ya existente, selecciona el theme desde Keycloak:

1. Entra al Admin Console.
2. Selecciona el realm.
3. Ve a Realm settings > Themes.
4. Cambia Login theme a `hort`.
5. Guarda.

Si el realm se importa desde cero, `Hort-realm.json` ya aplica el theme definido por `HORT_LOGIN_THEME`.

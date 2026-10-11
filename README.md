# gestor_cafeteria

Cliente Flutter de una cafetería. Traduce las respuestas HTTP del servidor de pedidos a errores tipados (`Failure`) y los prueba sin red, con un `MockClient`.

## Requisitos

- Flutter
- Node.js 22.13 o superior (`node --version`)

## Servidor

`mini_backend` es otro repositorio.

- Repositorio: https://github.com/DMI-2026/mini_backend
- Versión probada: rama `master`, consultada el 10 de octubre de 2026

```bash
git clone https://github.com/DMI-2026/mini_backend.git
cd mini_backend
node server.js
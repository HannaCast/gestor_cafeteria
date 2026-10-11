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

```

Debe quedar escuchando en el puerto 8000. En el navegador, http://localhost:8000/health responde `{"status":"ok"}`.

## App

En Chrome, en la misma computadora que el servidor:

```bash
flutter run -d chrome --dart-define=API_URL=http://127.0.0.1:8000
```

En el emulador de Android:

```bash
flutter run --dart-define=API_URL=http://10.0.2.2:8000
```

## Pruebas

```bash
flutter test
flutter analyze
```

Las pruebas de `ApiClient` usan `MockClient`. No necesitan el servidor ni la red.

## Carpetas

- `lib/core/failure.dart`: tipos de error
- `lib/core/http_client.dart`: cliente HTTP
- `lib/main.dart`: arranque de la app
- `test/core/`: pruebas de `Failure` y de `ApiClient`
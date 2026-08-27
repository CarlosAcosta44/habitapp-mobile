# Stack Tecnológico: Frontend Móvil

Este documento define estrictamente las herramientas, librerías y SDKs que utilizaremos para construir HabitApp en su versión móvil. Su objetivo es unificar el conocimiento de todos los desarrolladores y agentes de IA involucrados.

## 1. Core Framework
*   **Flutter (SDK):** Framework principal para desarrollo multiplataforma (iOS/Android).
*   **Dart:** Lenguaje de programación nativo de Flutter.
*   *(Nota: Asegurarse de usar la última versión estable de Flutter con Sound Null Safety).*

## 2. Gestión de Estado e Inyección de Dependencias
*   **Riverpod (`flutter_riverpod`):** 
    *   **Uso:** Gestión de estado global, caché de peticiones, e inyección de dependencias. 
    *   **Por qué:** Detecta errores en tiempo de compilación, no depende del `BuildContext` para la inyección y es el estándar moderno preferido por la comunidad. Sustituye la necesidad de usar `GetIt`.
    *   **Generador (`riverpod_annotation` & `riverpod_generator`):** Se utilizará el generador de código de Riverpod para escribir código más limpio y evitar errores manuales.

## 3. Redes y Consumo de API (Backend NestJS)
*   **Dio (`dio`):**
    *   **Uso:** Cliente HTTP principal.
    *   **Por qué:** Supera a `http` nativo porque permite interceptores fácilmente. 
    *   **Interceptor Auth:** Se configurará un interceptor que automáticamente añada el header `Authorization: Bearer <token>` a cada petición privada que vaya hacia `http://localhost:4000/api/v1`.

## 4. Enrutamiento y Navegación
*   **GoRouter (`go_router`):**
    *   **Uso:** Manejo de navegación basada en URLs (Deep linking) y protección de rutas.
    *   **Por qué:** Es el paquete recomendado oficialmente por el equipo de Flutter. Facilita los *Guards* (redirecciones condicionales, ej. si expira el token, devolver al login).

## 5. Persistencia Local Segura
*   **Flutter Secure Storage (`flutter_secure_storage`):**
    *   **Uso:** Guardar encriptado el `access_token` y `refresh_token` provistos por el backend.
    *   **Por qué:** Usa el Keystore en Android y el Keychain en iOS, previniendo robo de credenciales.
*   **Shared Preferences (`shared_preferences`):**
    *   **Uso:** Solo para preferencias triviales (ej. tema oscuro/claro, si ya vio el tutorial inicial). ¡NUNCA guardar tokens aquí!

## 6. Modelado de Datos (Domain/Data)
*   **Freezed (`freezed` + `json_serializable`):**
    *   **Uso:** Generar clases inmutables y métodos de copiado (`copyWith`), además de facilitar la conversión JSON <-> Dart de las respuestas del backend.

## 7. UI y Gráficos
*   **FL Chart (`fl_chart`):**
    *   **Uso:** Para construir las métricas, barras de progreso de hábitos y gráficas de la pestaña de Reportes/Ranking.

## 8. Notificaciones
*   **Firebase Cloud Messaging (`firebase_messaging`):**
    *   **Uso:** Recepción de notificaciones push enviadas desde el backend para recordar hábitos pendientes.

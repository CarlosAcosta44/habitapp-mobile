# Revisión Crítica del Backlog (Orientado a Móvil)

Tras analizar el documento PDF original (Backlog) y cruzarlo con el estado actual del proyecto (donde el Backend en NestJS ya asume toda la lógica de negocio, base de datos, triggers y cálculos), el Backlog original presenta varias **tareas obsoletas o mal enfocadas** que deben reescribirse para el contexto del desarrollo Móvil con Flutter.

## 1. Análisis de Estado por Épicas

*   **EPIC01 (Autenticación y Perfil):** Las historias US001 a US004 y US009 están vigentes a nivel visual, pero las tareas descritas ("Validar formato", "Trigger en BD", "Middleware de rutas") **ya están resueltas por el Backend**. En móvil, el esfuerzo es 100% diseño UI, consumo de API (HTTP POST), manejo seguro del JWT en `flutter_secure_storage` y enrutamiento (ej. GoRouter).
*   **EPIC02 (Administrador):** Tareas como US005, US006, US007 y US008 (Banear, cambiar roles, borrar posts) **no deben priorizarse en la app móvil inicial**. Son flujos de Backoffice que típicamente se consumen en el Frontend Web (Next.js). Se sugiere sacarlas del Backlog Móvil para el MVP.
*   **EPIC03 y EPIC04 (Core Hábitos y Progreso):** Las historias US010 a US020 son el corazón de la App. Nuevamente, el backend ya calcula las rachas y puntos (US019, US020, US003). La app móvil solo debe renderizar la respuesta del API y pintar las gráficas de progreso.
*   **EPIC05 (Entrenador):** Flujos específicos para entrenadores (crear rutinas, asignar a clientes). Se deben priorizar después del Core del usuario regular.
*   **EPIC06 (Comunidad):** Plenamente aplicable a móvil. Consumo de endpoints de posts, comentarios y likes.
*   **EPIC07 (Privacidad/RLS):** Totalmente obsoleta para el equipo Frontend. La seguridad por JWT y RLS ya fue implementada y blindada en NestJS y Supabase.

## 2. Historias de Usuario Faltantes para Móvil
El backlog original carece de elementos técnicos exclusivos de una aplicación móvil:
*   **NUEVA US-MOV-01:** Como usuario, deseo ver pantallas de onboarding y bienvenida al instalar la app por primera vez, para entender los beneficios de HabitApp. *(Diseños: 1.Pre-inicio)*
*   **NUEVA US-MOV-02:** Como usuario, deseo recibir notificaciones push locales o remotas en mi dispositivo, para recordar mis hábitos pendientes.
*   **NUEVA US-MOV-03:** Como usuario, deseo mantener mi sesión abierta de forma persistente y segura en mi teléfono, sin tener que loguearme cada vez que abro la app.
*   **NUEVA US-MOV-04:** Como usuario, deseo visualizar mis reportes y ranking en gráficas nativas optimizadas para mi pantalla. *(Diseños: 8.Reportes-ranking)*

## 3. Reestructuración de Tareas (Ejemplo Práctico)

*Antes (US001 - Breiner/Carlos):* "Diseño UI, Endpoint en NestJS, Validaciones, Pruebas unitarias BD".
*Ahora (US001 - Móvil Flutter):* 
1. Maquetación de pantallas de Login y Registro (Dart/Flutter).
2. Integración de paquete HTTP (Dio/Http) para consumir `POST /auth/login` y `POST /auth/register`.
3. Almacenamiento seguro del JWT (Flutter Secure Storage).
4. Implementación de Login Social nativo (Google/Facebook/Microsoft SDKs).

## 4. Estrategia de Asignación Colaborativa (Equipo de 4)

A diferencia de un enfoque en cascada donde una persona hace todo un módulo, en Scrum todos los miembros deben trabajar simultáneamente durante el Sprint. Para lograr esto sin crear conflictos de código en Git, el trabajo se dividirá por **Capas Arquitectónicas (Lógica vs UI)** o dividiendo las **Vistas de un mismo módulo**.

**Patrón general de división por Sprint para 4 integrantes:**
1.  **Dev A (Lógica Core y APIs):** Crea los Modelos, Servicios (HTTP) y lógica del gestor de estado para el módulo del Sprint.
2.  **Dev B (UI Pantalla Principal):** Maqueta la pantalla principal del módulo y la conecta con la lógica creada por el Dev A.
3.  **Dev C (UI Flujo Secundario):** Maqueta pantallas de detalle o flujos alternos (ej. creación, modales).
4.  **Dev D (Componentes y Validación):** Desarrolla componentes reutilizables (botones, inputs, tarjetas), implementa validaciones de formularios y ayuda en la integración final.

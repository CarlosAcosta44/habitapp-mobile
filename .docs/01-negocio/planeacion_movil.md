# Planeación y Estrategia Móvil (Flutter)

Este documento detalla el plan de acción para construir `HabitAppFrontend`. El plan está dividido en **3 Sprints intensivos**, asegurando que **Carlos, Breiner, Nicolas y Juan trabajen simultáneamente**, dividiendo tareas por capas de la arquitectura (Data, Providers, UI) para evitar conflictos.

## Sprint 1: Setup Base, Onboarding y Autenticación
**Objetivo:** Tener la app configurada (Riverpod, Dio, GoRouter) y con todo el flujo de ingreso funcionando (registro, login, almacenamiento de JWT).

*   **Carlos (Setup y Lógica Auth):** 
    *   Crea el proyecto Flutter y estructura las carpetas según `arquitectura_base.md`.
    *   Implementa `AuthRepository` (capa data) y `AuthProvider` (Riverpod) para conectar con NestJS.
*   **Breiner (Infraestructura HTTP y UI Base):** 
    *   Configura el cliente HTTP (Dio) con interceptores para inyectar y renovar tokens.
    *   Maqueta el carrusel y las pantallas de bienvenida (`1.Pre-inicio`).
*   **Nicolas (Navegación y Login):** 
    *   Configura `GoRouter` y la redirección por estado (ej. redirigir si `AuthProvider` tiene sesión).
    *   Maqueta la pantalla de `2.Iniciar sesion` e integra los Providers.
*   **Juan (Tema y Registro):** 
    *   Configura el `AppTheme` global.
    *   Maqueta la pantalla de `3.Crear cuenta` y maneja las validaciones de formulario.

---

## Sprint 2: Core de Hábitos y Perfil de Usuario
**Objetivo:** El usuario ve sus hábitos, los completa, crea nuevos y gestiona su perfil.

*   **Juan (Lógica Core Hábitos):** 
    *   Desarrolla `HabitsRepository` y `HabitsProvider` para traer hábitos diarios y emitir checks al backend.
*   **Carlos (Dashboard y Reactividad UI):** 
    *   Maqueta el `4.Dashboard` y la barra de navegación principal.
    *   Conecta la vista con `HabitsProvider` asegurando *Optimistic UI* (reacción instantánea al tocar un hábito).
*   **Breiner (Formularios y Accesos):** 
    *   Maqueta la pantalla de `5.Crear-habitos` (formularios complejos) y su Provider asociado.
*   **Nicolas (Cuenta de Usuario):** 
    *   Maqueta `9.Perfil` (Logros básicos) y `10.Ajustes` (Edición de cuenta y funcionalidad de Logout con limpieza de tokens y estado).

---

## Sprint 3: Engagement (Comunidad, Retos y Reportes) + Despliegue
**Objetivo:** Integrar el componente social, gamificación y compilar la app final.

*   **Nicolas (Lógica Social y Gráficos):** 
    *   Crea repositorios y providers para Comunidad y Retos.
    *   Integra librerías nativas (`fl_chart`) para renderizar estadísticas en los reportes.
*   **Juan (UI Comunidad):** 
    *   Maqueta `7.Comunidad` (Muro/Feed) implementando Infinite Scroll en el ListView.
*   **Breiner (UI Retos y Ranking):** 
    *   Maqueta la pantalla `6.Retos` y la tabla de posiciones del ranking global.
*   **Carlos (Reportes, Notificaciones y QA):** 
    *   Maqueta `8.Reportes-ranking` (Mapas de calor).
    *   Integra Firebase Cloud Messaging (FCM) para notificaciones Push.
    *   Lidera el QA y la compilación para Android (APK) e iOS.

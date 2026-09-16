# Planeación y Estrategia Móvil (Flutter)

Este documento detalla el plan de acción para construir `HabitAppFrontend`. El plan está dividido en **4 Sprints intensivos**, asegurando que el trabajo se distribuya directamente según las Historias de Usuario (US) del `Backlog_Completo.md`.

## Sprint 1: Autenticación y Base
**Objetivo:** Tener la app configurada y con todo el flujo de ingreso funcionando (registro, login, perfil base).

*   **Juan & Carlos (Autenticación):** ✅ **COMPLETADO**
    *   [x] **US001:** Acceder a la plataforma de hábitos (Registro).
    *   [x] **US002:** Iniciar sesión de forma segura (Login).
*   **Nicolas (Perfil Base):** ✅ **COMPLETADO**
    *   [x] **US003:** Tener un perfil base listo apenas me registro.
*   **Juan (Configuración de Cuenta):** ✅ **COMPLETADO**
    *   [x] **US004:** Editar mi información personal y zona horaria.

---

## Sprint 2: Core de Hábitos y Dashboard
**Objetivo:** El usuario ve sus hábitos, los completa, crea nuevos y visualiza su racha.

*   **Nicolas (Navegación y Vistas):** ✅ **COMPLETADO**
    *   [x] **US009:** Que la app me exija iniciar sesión si intento entrar por enlace.
    *   [x] **US015:** Ver en la pantalla principal sólo los hábitos que tocan hoy.
    *   [x] **US018:** Ver una barra de progreso general de mi día.
*   **Breiner & Juan (Creación de Hábitos):** ✅ **COMPLETADO**
    *   [x] **US010:** Crear un hábito nuevo con nombre, etiqueta y frecuencia.
    *   [x] **US011:** Establecer en qué días específicos haré un hábito.
    *   [x] **US012:** Asignarle etiquetas de categorías a un hábito.
*   **Carlos (Gestión de Hábitos Existentes):** ✅ **COMPLETADO**
    *   [x] **US013:** Archivar un hábito que ya no quiero seguir.
    *   [x] **US014:** Eliminar permanentemente un hábito.
    *   [x] **US020:** Ganar puntos automáticamente al completar hábitos (BD/Servicio).
*   **Breiner & Juan (Progreso y Rachas):** ✅ **COMPLETADO**
    *   [x] **US016:** Marcar fácilmente cuando cumplí mi hábito.
    *   [x] **US017:** Que mis hábitos respeten mi zona horaria local.
    *   [x] **US019:** Ver cuántos días consecutivos llevo cumpliendo un hábito (Streak).

---

## Sprint 3: Comunidad, Retos y Gráficas
**Objetivo:** Integrar el componente social, gamificación y gráficos de progreso.

*   **Breiner (Engagement y Reportes):**
    *   [x] **US032:** Participación en Retos de la Comunidad.
    *   [ ] **US025:** Leer publicaciones en el muro de la comunidad.
    *   [x] **US031:** Visualizar mis reportes y ranking en gráficas nativas.
*   **Backend (Seguridad - Ya terminado):** ✅ **COMPLETADO**
    *   [x] **US026:** Que mi información sea estrictamente privada (RLS).
    *   [x] **US027:** Verificación de identidad con JWT.
*   **Carlos (Onboarding):** ✅ **COMPLETADO**
    *   [x] **US028:** Ver pantallas de onboarding y bienvenida.
*   **Juan (Notificaciones):**
    *   [ ] **US029:** Recibir notificaciones push locales o remotas.
*   **Nicolas (Persistencia):** ✅ **COMPLETADO**
    *   [x] **US030:** Mantener mi sesión abierta persistente y segura.

---

## Sprint 4: Módulo de Entrenador (Coach) y Hardware
**Objetivo:** Desarrollar herramientas para entrenadores y aprovechar características nativas del dispositivo.

*   **Juan (Core Entrenador):**
    *   [ ] **US021:** Ver el listado de mis clientes asignados.
    *   [ ] **US022:** Crear rutinas modelo agrupando varios hábitos.
*   **Nicolas (Interacción Cliente-Coach):**
    *   [ ] **US023:** Asignar una rutina prearmada a un cliente.
    *   [ ] **US024:** Visualización de Progreso del Cliente.
*   **Breiner (Ubicación):**
    *   [ ] **US033:** Utilizar mi ubicación (GPS).
*   **Carlos (Cámara y Biometría):**
    *   [ ] **US034:** Subir imágenes desde Cámara/Galería.
    *   [ ] **US035:** Seguridad Biométrica (Huella / FaceID).

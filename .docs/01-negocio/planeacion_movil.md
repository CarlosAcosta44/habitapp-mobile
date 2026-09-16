# Planeación y Estrategia Móvil (Flutter)

Este documento detalla el plan de acción para construir `HabitAppFrontend`. El plan está dividido en **4 Sprints intensivos**, asegurando que el trabajo se distribuya directamente según las Historias de Usuario (US) del `Backlog_Completo.md`.

## Sprint 1: Autenticación y Base
**Objetivo:** Tener la app configurada y con todo el flujo de ingreso funcionando (registro, login, perfil base).

*   **Carlos:** ✅ **COMPLETADO**
    *   [x] **US001:** Acceder a la plataforma de hábitos (Registro).
    *   [x] **US003:** Tener un perfil base listo apenas me registro.
*   **Nicolas:** ✅ **COMPLETADO**
    *   [x] **US002:** Iniciar sesión de forma segura (Login).
    *   [x] **US030:** Mantener mi sesión abierta persistente y segura.
*   **Breiner:** ✅ **COMPLETADO**
    *   [x] **US028:** Ver pantallas de onboarding y bienvenida.

---

## Sprint 2: Core de Hábitos y Dashboard
**Objetivo:** El usuario ve sus hábitos, los completa, crea nuevos y visualiza su racha.

*   **Carlos:** ✅ **COMPLETADO**
    *   [x] **US013:** Archivar un hábito que ya no quiero seguir.
    *   [x] **US015:** Ver en la pantalla principal sólo los hábitos que tocan hoy.
    *   [x] **US017:** Que mis hábitos respeten mi zona horaria local.
    *   [x] **US019:** Ver cuántos días consecutivos llevo cumpliendo un hábito (Streak).
*   **Nicolas:** ✅ **COMPLETADO**
    *   [x] **US004:** Editar mi información personal y zona horaria.
    *   [x] **US009:** Que la app me exija iniciar sesión si intento entrar por enlace.
*   **Breiner:** ✅ **COMPLETADO**
    *   [x] **US010:** Crear un hábito nuevo con nombre, etiqueta y frecuencia.
    *   [x] **US011:** Establecer en qué días específicos haré un hábito.
    *   [x] **US012:** Asignarle etiquetas de categorías a un hábito.
*   **Juan:** ✅ **COMPLETADO**
    *   [x] **US014:** Eliminar permanentemente un hábito.
    *   [x] **US016:** Marcar fácilmente cuando cumplí mi hábito.
    *   [x] **US018:** Ver una barra de progreso general de mi día.
    *   [x] **US020:** Ganar puntos automáticamente al completar hábitos (BD/Servicio).

---

## Sprint 3: Comunidad, Retos y Gráficas
**Objetivo:** Integrar el componente social, gamificación y gráficos de progreso.

*   **Carlos:** ✅ **COMPLETADO**
    *   [x] **US029:** Recibir notificaciones push locales o remotas.
*   **Nicolas:** ✅ **COMPLETADO**
    *   [x] **US031:** Visualizar mis reportes y ranking en gráficas nativas.
*   **Breiner:**
    *   [x] **US032:** Participación en Retos de la Comunidad.
*   **Juan:**
    *   [ ] **US025:** Leer publicaciones en el muro de la comunidad.
*   **Backend (Seguridad - Ya terminado):** ✅ **COMPLETADO**
    *   [x] **US026:** Que mi información sea estrictamente privada (RLS).
    *   [x] **US027:** Verificación de identidad con JWT.

---

## Sprint 4: Módulo de Entrenador (Coach) y Hardware
**Objetivo:** Desarrollar herramientas para entrenadores y aprovechar características nativas del dispositivo.

*   **Carlos:**
    *   [ ] **US034:** Subir imágenes desde Cámara/Galería.
    *   [ ] **US035:** Seguridad Biométrica (Huella / FaceID).
*   **Nicolas:**
    *   [ ] **US023:** Asignar una rutina prearmada a un cliente.
    *   [ ] **US024:** Visualización de Progreso del Cliente.
*   **Breiner:**
    *   [ ] **US033:** Utilizar mi ubicación (GPS).
*   **Juan:**
    *   [ ] **US021:** Ver el listado de mis clientes asignados.
    *   [ ] **US022:** Crear rutinas modelo agrupando varios hábitos.

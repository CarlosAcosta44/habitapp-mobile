# Backlog Maestro Completo de Historias de Usuario (US001 - US035)

Este documento contiene la planificación completa y optimizada del proyecto HabitApp. Todas las tareas técnicas han sido detalladas y sus tiempos estimados han sido ajustados a un desarrollo acelerado mediante el uso de asistentes y agentes de Inteligencia Artificial.

---

## Sprint 1: Autenticación y Base

### US001 - Acceder a la plataforma de hábitos
**Como** usuario nuevo  
**Deseo** registrarme con mi correo y una contraseña  
**Para** acceder a la plataforma de hábitos

**Criterios de Aceptación:**
- El sistema debe validar que el correo tenga un formato válido mediante expresiones regulares.
- La contraseña debe cumplir con políticas de seguridad básicas (mínimo 6 caracteres).
- Si el correo ya existe, el sistema debe mostrar un `SnackBar` con un mensaje de error amigable.
- Al ser exitoso el registro, debe generarse un UUID y crear automáticamente el registro en la tabla `user_profiles`.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 90  
**Estado:** ✅ Terminado | **Dependencias:** Ninguna | **Sprint:** 1

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI de Registro** | Maquetar la pantalla de registro con validaciones de formulario reactivas y diseño base. | 1.0 h | Carlos |
| **2. API POST /register** | Integrar `Dio` para consumir el endpoint de registro, mapeando excepciones del servidor. | 0.5 h | Juan |
| **3. Manejo de Token** | Guardar el JWT devuelto en `flutter_secure_storage` para persistencia de sesión. | 0.5 h | Juan |

### US002 - Iniciar sesión de forma segura
**Como** usuario registrado  
**Deseo** iniciar sesión de forma segura  
**Para** entrar a mi panel de control

**Criterios de Aceptación:**
- El sistema debe verificar la correspondencia exacta de credenciales con la base de datos (Supabase Auth).
- En caso de credenciales inválidas, el error no debe especificar si falló el correo o la clave por motivos de seguridad.
- Al iniciar sesión correctamente, el usuario es redirigido inmediatamente al Dashboard principal.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 90  
**Estado:** ✅ Terminado | **Dependencias:** US001 | **Sprint:** 1

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI de Login** | Crear pantalla de Login reutilizando componentes de texto y botones del Registro. | 1.0 h | Carlos |
| **2. Conexión de Login** | Configurar el consumo del endpoint de Auth y guardar credenciales en el estado global. | 1.0 h | Juan |
| **3. Enrutamiento** | Configurar redirección automática con `GoRouter` una vez el estado de autenticación cambie. | 0.5 h | Juan |

### US003 - Tener un perfil base listo apenas me registro
**Como** usuario nuevo  
**Deseo** tener un perfil base listo apenas me registro  
**Para** empezar a usar la app de inmediato

**Criterios de Aceptación:**
- El backend debe insertar automáticamente valores por defecto (ej. avatar genérico) en `user_profiles`.
- El frontend debe recuperar y mostrar esta información en el estado global sin necesidad de un refresh manual.

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 80  
**Estado:** ✅ Terminado | **Dependencias:** US001 | **Sprint:** 1

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Estado de Perfil (Riverpod)** | Crear un Provider que mantenga en memoria los datos del usuario logueado. | 1.0 h | Nicolas |
| **2. Sincronización Inicial** | Hacer un fetch del perfil inmediatamente después del login exitoso. | 0.5 h | Nicolas |

### US004 - Editar mi información personal y zona horaria
**Como** usuario  
**Deseo** editar mi información personal y zona horaria  
**Para** personalizar mi perfil

**Criterios de Aceptación:**
- El usuario puede editar su nombre a través de un formulario con validación de campos vacíos.
- El sistema detecta y guarda automáticamente la zona horaria del dispositivo (ej. UTC-5) para ajustar las notificaciones.
- Los cambios se reflejan instantáneamente en la UI gracias a la gestión de estado reactiva.

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 55  
**Estado:** ✅ Terminado | **Dependencias:** US003 | **Sprint:** 1

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI Edición de Perfil** | Pantalla con campos de texto pre-llenados con la información actual del usuario. | 1.0 h | Juan |
| **2. DTO y API PATCH** | Definir el DTO en Dart y consumir el endpoint de actualización de perfil de usuario. | 1.0 h | Juan |
| **3. Detección de Zona Horaria** | Usar paquete nativo para obtener el TimeZone y enviarlo silenciosamente en el payload. | 0.5 h | Juan |

---

## Sprint 2: Core de Hábitos y Dashboard

### US009 - Que la app me exija iniciar sesión si intento entrar por enlace
**Como** usuario  
**Deseo** que la app me exija iniciar sesión si intento entrar por enlace profundo (Deep Link)  
**Para** proteger mi privacidad

**Criterios de Aceptación:**
- Cualquier intento de navegación a una ruta protegida (ej. `/dashboard`) sin token válido redirecciona a `/login`.
- El estado de la ruta intentada puede ser recordado para redirigir tras el login (opcional).

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 75  
**Estado:** ✅ Terminado | **Dependencias:** US002 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Guardias de Ruta (GoRouter)** | Implementar validación lógica en el `redirect` del router basándose en el AuthProvider. | 1.0 h | Nicolas |

### US010 - Crear un hábito nuevo con nombre, etiqueta y frecuencia
**Como** usuario  
**Deseo** crear un hábito nuevo con nombre, etiqueta y frecuencia  
**Para** empezar a hacerle seguimiento

**Criterios de Aceptación:**
- El nombre del hábito es obligatorio.
- La frecuencia diaria es obligatoria (ej. "3 veces al día").
- Una vez creado en BD, el hábito aparece en la lista principal sin necesidad de recargar la aplicación.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 85  
**Estado:** ✅ Terminado | **Dependencias:** Ninguna | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Formulario de Creación UI** | Construir la vista con inputs para nombre, descripción, frecuencia e icono representativo. | 1.5 h | Breiner |
| **2. Conexión de API Hábitos** | Crear los modelos y consumir el método POST `/habits` usando el cliente HTTP de la app. | 1.0 h | Juan |
| **3. Invalidación de Estado** | Configurar Riverpod para que invalide la lista de hábitos al completar el POST exitosamente. | 0.5 h | Breiner |

### US011 - Establecer en qué días específicos haré un hábito
**Como** usuario  
**Deseo** establecer en qué días específicos haré un hábito  
**Para** adaptarlo a mi rutina personal

**Criterios de Aceptación:**
- Interfaz gráfica intuitiva con los 7 días de la semana seleccionables (toggle).
- El sistema no permite guardar el hábito si no hay al menos un día seleccionado.
- El backend registra los días como un array o representación binaria (ej. `[1,3,5]`).

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 55  
**Estado:** ✅ Terminado | **Dependencias:** US010 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Componente Selector de Días** | Crear un Widget de selección múltiple (L,M,M,J,V,S,D) que maneje su estado local. | 1.0 h | Breiner |
| **2. Parseo y Envío JSON** | Convertir la selección de la UI en el arreglo de enteros esperado por el DTO del backend. | 0.5 h | Juan |

### US012 - Asignarle etiquetas de categorías a un hábito
**Como** usuario  
**Deseo** asignarle etiquetas de categorías a un hábito  
**Para** organizar mis metas

**Criterios de Aceptación:**
- El usuario puede elegir una categoría predefinida (Salud, Trabajo, Deporte).
- En el dashboard, el hábito mostrará un chip o un color representativo de su categoría.

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 50  
**Estado:** ✅ Terminado | **Dependencias:** US010 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Dropdown de Categorías** | Implementar un menú desplegable en el formulario consultando las categorías maestras. | 1.0 h | Breiner |

### US013 - Archivar un hábito que ya no quiero seguir
**Como** usuario  
**Deseo** archivar un hábito que ya no quiero seguir  
**Para** sacarlo de mi vista principal sin perder su historial

**Criterios de Aceptación:**
- El hábito se marca en base de datos como "Inactivo" y desaparece del Dashboard.
- El historial de estadísticas y rachas se mantiene intacto para reportes históricos.

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 65  
**Estado:** ✅ Terminado | **Dependencias:** US010 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Endpoint Update** | Enviar evento `PATCH` cambiando el `estado` a Inactivo. | 0.5 h | Carlos |
| **2. Filtro en Dashboard** | Asegurar que el listado principal filtre e ignore elementos inactivos o archivados. | 0.5 h | Carlos |

### US014 - Eliminar permanentemente un hábito
**Como** usuario  
**Deseo** eliminar permanentemente un hábito  
**Para** borrar errores de mi lista

**Criterios de Aceptación:**
- Se requiere confirmación obligatoria mediante un `AlertDialog` antes de eliminar.
- Al confirmar, el hábito es borrado de la base de datos (hard delete o soft delete validado).

**Prioridad:** Could Have (3) | **Esfuerzo:** 3 | **Valor Negocio:** 30  
**Estado:** ✅ Terminado | **Dependencias:** US010 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Cuadro de Confirmación UI** | Implementar el Dialog de advertencia destructiva. | 0.5 h | Carlos |
| **2. Conexión de API DELETE** | Integrar el endpoint de borrado y actualizar el estado de Riverpod. | 0.5 h | Carlos |

### US015 - Ver en la pantalla principal sólo los hábitos que tocan hoy
**Como** usuario  
**Deseo** ver en la pantalla principal sólo los hábitos que tocan hoy  
**Para** no distraerme con otros

**Criterios de Aceptación:**
- El Dashboard compara el día actual (ej. Lunes) con el arreglo de días permitidos de cada hábito.
- Los hábitos que no tocan hoy se ocultan completamente de la lista de tareas del día.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 85  
**Estado:** ✅ Terminado | **Dependencias:** US011 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Lógica de Filtrado Local** | Usar Dart `DateTime.now().weekday` para filtrar la lista recibida por la API antes de renderizar. | 1.0 h | Nicolas |

### US016 - Marcar fácilmente cuando cumplí mi hábito
**Como** usuario  
**Deseo** marcar fácilmente cuando cumplí mi hábito  
**Para** registrar mi progreso diario

**Criterios de Aceptación:**
- Al hacer tap en el hábito, el estado cambia a completado para el día actual.
- Debe reproducirse una micro-animación de éxito (ej. check, confeti o sonido).
- La acción debe ser reversible (desmarcar) en caso de error en el mismo día.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 85  
**Estado:** ✅ Terminado | **Dependencias:** US015 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI Animada Checkbox** | Crear widget interactivo que cambie de estado y lance animación sutil. | 1.0 h | Breiner |
| **2. Sincronización API** | Enviar POST a la tabla de `registros_diarios` de manera optimista. | 1.0 h | Breiner |

### US017 - Que mis hábitos respeten mi zona horaria local
**Como** usuario viajero  
**Deseo** que mis hábitos respeten mi zona horaria local  
**Para** no perder mis rachas

**Criterios de Aceptación:**
- Las fechas en base de datos deben ser tratadas con `Timestamptz`.
- El frontend debe convertir cualquier registro de fecha a la zona horaria del dispositivo del usuario antes de evaluarla.

**Prioridad:** Must Have (1) | **Esfuerzo:** 8 | **Valor Negocio:** 70  
**Estado:** ✅ Terminado | **Dependencias:** US004 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Manejo de DateTime en Dart** | Configurar interceptores para estandarizar todas las fechas en formato ISO UTC antes de enviar. | 1.5 h | Juan |

### US018 - Ver una barra de progreso general de mi día
**Como** usuario  
**Deseo** ver una barra de progreso general de mi día  
**Para** sentirme motivado a llegar al 100%

**Criterios de Aceptación:**
- Mostrar un `LinearProgressIndicator` (o similar) que calcule: `(hábitos completados hoy / total de hábitos programados para hoy) * 100`.
- El progreso debe animarse fluidamente cada vez que se completa un hábito.

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 50  
**Estado:** ✅ Terminado | **Dependencias:** US016 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Widget Indicador** | Construir un header en el Dashboard con la barra y cálculo dinámico derivado de la lista filtrada. | 1.0 h | Nicolas |

### US019 - Ver cuántos días consecutivos llevo cumpliendo un hábito
**Como** usuario  
**Deseo** ver cuántos días consecutivos llevo cumpliendo un hábito  
**Para** no querer romper mi racha

**Criterios de Aceptación:**
- El backend evalúa la continuidad de los registros basándose en los días configurados del hábito.
- Mostrar visualmente (ej. ícono de fuego 🔥) el número consecutivo (streak) en la tarjeta del hábito.

**Prioridad:** Must Have (1) | **Esfuerzo:** 8 | **Valor Negocio:** 80  
**Estado:** ✅ Terminado | **Dependencias:** US016 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Query SQL de Racha** | Escribir lógica de backend/Supabase RPC para calcular el streak eficientemente. | 2.0 h | Juan |
| **2. UI del Streak** | Añadir el indicador en las tarjetas de hábitos. | 0.5 h | Juan |

### US020 - Ganar puntos automáticamente al completar hábitos
**Como** usuario  
**Deseo** ganar puntos automáticamente al completar hábitos  
**Para** sentir que subo de nivel

**Criterios de Aceptación:**
- Cada hábito tiene un valor de puntos. Completarlo hoy suma los puntos a la tabla global del usuario.
- Si se desmarca, los puntos se restan correctamente.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 65  
**Estado:** ✅ Terminado | **Dependencias:** US016 | **Sprint:** 2

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Trigger en BD / Lógica de Servicio** | Crear lógica backend atada a la inserción/borrado de registros diarios que actualice el saldo del usuario. | 1.5 h | Carlos |

---

## Sprint 3: Comunidad, Retos y Gráficas

### US032 - Participación en Retos de la Comunidad
**Como** usuario registrado  
**Deseo** visualizar y unirme a los retos de la comunidad  
**Para** ganar puntos adicionales y mantenerme motivado junto a otros usuarios.

**Criterios de Aceptación:**
- El usuario ve la lista de retos activos con sus premios en puntos.
- Al unirse, el sistema valida que no esté previamente inscrito y cambia su estado.
- El progreso grupal del reto es visible en la UI.

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 70  
**Estado:** ⬜ Por Hacer | **Dependencias:** US020 | **Sprint:** 3

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Maquetación UI de Retos** | Crear la pantalla principal de "Retos" (lista de tarjetas) y la vista de detalle. | 1.5 h | Breiner |
| **2. Integración API Retos** | Consumir el endpoint `GET /api/v1/community/retos`. Crear modelo Freezed. | 1.0 h | Breiner |
| **3. Lógica de Estado** | Provider que maneje estados (cargando, lista) y exponga método `joinChallenge`. | 1.0 h | Breiner |

### US025 - Leer publicaciones en el muro de la comunidad
**Como** usuario  
**Deseo** leer publicaciones en el muro de la comunidad  
**Para** aprender consejos de los expertos

**Criterios de Aceptación:**
- Mostrar feed cronológico con títulos, extractos y autores (coaches/admin).
- Soporte para pull-to-refresh para actualizar artículos de forma fluida.

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 50  
**Estado:** ⬜ Por Hacer | **Dependencias:** Ninguna | **Sprint:** 3

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Consumo API Comunidad** | Fetch de artículos paginados y renderizado en UI de ListView estético. | 1.5 h | Breiner |

### US026 - Que mi información de salud y hábitos sea estrictamente privada
**Como** usuario  
**Deseo** que mi información de salud y hábitos sea estrictamente privada  
**Para** tener confianza

**Criterios de Aceptación:**
- Configuración sólida de Row Level Security (RLS) en base de datos.
- Imposibilidad técnica de consultar datos de otros usuarios a través de la API pública.

**Prioridad:** Must Have (1) | **Esfuerzo:** 8 | **Valor Negocio:** 90  
**Estado:** ✅ Terminado | **Dependencias:** Ninguna | **Sprint:** 3

*(Implementado a nivel infraestructura backend mediante Supabase)*

### US027 - Que el sistema verifique mi identidad en cada paso
**Como** usuario  
**Deseo** que el sistema verifique mi identidad en cada paso  
**Para** estar seguro de que nadie puede actuar en mi nombre

**Criterios de Aceptación:**
- Todo endpoint privado requiere Bearer JWT válido.
- Expiración de sesión manejada correctamente con códigos `401 Unauthorized`.

**Prioridad:** Must Have (1) | **Esfuerzo:** 8 | **Valor Negocio:** 90  
**Estado:** ✅ Terminado | **Dependencias:** Ninguna | **Sprint:** 3

*(Implementado mediante interceptores Dio y NestJS Guards)*

### US028 - Ver pantallas de onboarding y bienvenida al instalar la app
**Como** usuario  
**Deseo** ver pantallas de onboarding y bienvenida al instalar la app  
**Para** entender la app al inicio

**Criterios de Aceptación:**
- Presentar 3 o 4 pantallas (PageView) explicando la propuesta de valor.
- Mostrar botón "Saltar" funcional. Solo se muestra si es la primera ejecución tras instalar.

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 80  
**Estado:** ✅ Terminado | **Dependencias:** Ninguna | **Sprint:** 3

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI de Onboarding** | Maquetación interactiva con `PageView`, dots indicators y almacenamiento de flag `isFirstTime` (shared_preferences). | 1.5 h | Carlos |

### US029 - Recibir notificaciones push locales o remotas
**Como** usuario  
**Deseo** recibir notificaciones push locales o remotas  
**Para** recordar mis hábitos

**Criterios de Aceptación:**
- Notificaciones locales programadas para recordatorios diarios de la app (ej. 8:00 AM "No olvides tus hábitos").
- Opción de configuración para activar/desactivar notificaciones desde los ajustes.

**Prioridad:** Should Have (2) | **Esfuerzo:** 8 | **Valor Negocio:** 90  
**Estado:** ⬜ Por Hacer | **Dependencias:** Ninguna | **Sprint:** 3

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Paquete Notificaciones** | Integrar `flutter_local_notifications`, solicitar permisos OS nativos y disparar alerta base. | 2.0 h | Juan |

### US030 - Mantener mi sesión abierta persistente y segura
**Como** usuario  
**Deseo** mantener mi sesión abierta persistente y segura  
**Para** no loguearme cada vez

**Criterios de Aceptación:**
- Al reabrir la app, el sistema evalúa el JWT en Storage. Si es válido, navega directo a Dashboard.
- El proceso debe ser imperceptible para el usuario (se realiza durante el Splash Screen).

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 100  
**Estado:** ✅ Terminado | **Dependencias:** US002 | **Sprint:** 3

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Router Initialization** | Leer almacenamiento seguro antes de cargar la app y proveer el estado inicial a GoRouter. | 1.0 h | Nicolas |

### US031 - Visualizar mis reportes y ranking en gráficas nativas
**Como** usuario  
**Deseo** visualizar mis reportes y ranking en gráficas nativas  
**Para** ver mi progreso en un pantallazo

**Criterios de Aceptación:**
- Gráfico de barras (BarChart) mostrando completados por día en la última semana o mes.
- Tooltips interactivos al tocar las barras de las gráficas.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 85  
**Estado:** ✅ Terminado | **Dependencias:** US016 | **Sprint:** 3

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI de Gráficos (fl_chart)** | Crear componentes visuales dinámicos alimentados por el API de reportes. | 2.0 h | Breiner |

---

## Sprint 4: Módulo de Entrenador (Coach) y Hardware

### US021 - Ver el listado de mis clientes asignados
**Como** entrenador  
**Deseo** ver el listado de mis clientes asignados  
**Para** saber exactamente a quiénes debo hacer seguimiento y auditar.

**Criterios de Aceptación:**
- El coach entra a su panel y ve la lista de sus pupilos activos.
- Si no tiene clientes, se muestra un estado vacío amigable (empty state).
- La información mostrada debe respetar RLS de entrenador/cliente.

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 80  
**Estado:** ⬜ Por Hacer | **Dependencias:** Ninguna | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI Panel Entrenador** | Diseñar el Dashboard exclusivo del rol "Coach", mostrando lista de clientes activos. | 1.5 h | Juan |
| **2. API Clientes Coach** | Integrar endpoint de obtención de clientes, pasando el Token del Coach adecuadamente. | 0.5 h | Juan |
| **3. Gestión de Estado** | Implementar Provider que traiga lista de clientes con soporte para "pull-to-refresh". | 0.5 h | Juan |

### US022 - Crear rutinas modelo agrupando varios hábitos
**Como** entrenador  
**Deseo** crear rutinas modelo agrupando varios hábitos  
**Para** organizar mis planes por objetivos específicos (ej. "Bajar de peso en 30 días") y reutilizarlos.

**Criterios de Aceptación:**
- El entrenador guarda una rutina con un nombre y múltiples hábitos anidados.
- Si falta el nombre o no hay hábitos agregados, el botón de guardar se deshabilita visualmente.

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 85  
**Estado:** ⬜ Por Hacer | **Dependencias:** US021 | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Formulario Dinámico** | Maquetar formulario donde Coach añade "N" cantidad de hábitos dinámicos a una rutina. | 1.5 h | Juan |
| **2. Integración POST** | Mapear los datos a un JSON anidado y consumir endpoint de creación de rutinas maestras. | 1.0 h | Juan |
| **3. Validaciones** | Implementar validaciones reactivas (mínimo 1 hábito, nombre obligatorio). | 0.5 h | Juan |

### US023 - Asignar una rutina prearmada a un cliente
**Como** entrenador  
**Deseo** asignar una rutina prearmada a un cliente específico  
**Para** facilitarle el inicio en la plataforma sin que él tenga que crear los hábitos uno por uno.

**Criterios de Aceptación:**
- Permite seleccionar un cliente de la lista y una rutina disponible (Dropdown).
- Una vez enviada, los hábitos se copian masivamente a la tabla del cliente objetivo, activándolos inmediatamente y notificándole.

**Prioridad:** Must Have (1) | **Esfuerzo:** 3 | **Valor Negocio:** 90  
**Estado:** ⬜ Por Hacer | **Dependencias:** US022 | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Modal de Asignación** | Dialog/BottomSheet para seleccionar cliente y elegir la rutina. | 1.0 h | Nicolas |
| **2. API de Asignación** | Conectar con el endpoint de acción masiva, capturando y mostrando posibles errores API. | 0.5 h | Nicolas |

### US024 - Visualización de Progreso del Cliente
**Como** entrenador  
**Deseo** ver el progreso diario y las estadísticas de mi cliente  
**Para** auditar su nivel de cumplimiento, felicitarlo o enviarle alertas.

**Criterios de Aceptación:**
- El coach accede a una versión de "solo lectura" del dashboard del cliente.
- Puede observar qué días de la semana falló el cliente según el modelo de datos.

**Prioridad:** Should Have (2) | **Esfuerzo:** 3 | **Valor Negocio:** 75  
**Estado:** ⬜ Por Hacer | **Dependencias:** US021 | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI de Reportes Reutilizable** | Adaptar vista `ReportsScreen` para inyectar un `userId` externo si se es Coach. | 1.5 h | Nicolas |
| **2. API Lectura Terceros** | Integrar endpoint de estadísticas de pupilos, validando correcto acceso RLS. | 1.0 h | Nicolas |

### US033 - Utilizar mi ubicación (GPS)
**Como** usuario  
**Deseo** utilizar mi ubicación geográfica  
**Para** descubrir entrenadores cercanos o registrar desde dónde he completado mis hábitos.

**Criterios de Aceptación:**
- La app solicita permiso OS nativo de forma clara; si concede, extrae la Lat/Long eficientemente.
- Si el usuario deniega el permiso permanentemente, el servicio falla silenciosamente y la app sigue operando normalmente.

**Prioridad:** Could Have (3) | **Esfuerzo:** 3 | **Valor Negocio:** 60  
**Estado:** ⬜ Por Hacer | **Dependencias:** Ninguna | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Permisos Nativo (geolocator)** | Configurar `AndroidManifest.xml` / `Info.plist` para permisos de ubicación. | 0.5 h | Breiner |
| **2. Servicio Geolocalización** | Clase `LocationService` que exponga la posición usando el sensor GPS en un Future. | 1.0 h | Breiner |

### US034 - Subir imágenes desde Cámara/Galería
**Como** usuario  
**Deseo** subir imágenes desde mi cámara/galería y adjuntar archivos  
**Para** actualizar mi foto de perfil y compartir documentos útiles.

**Criterios de Aceptación:**
- Permite seleccionar foto de galería o abrir cámara nativa sin crashear.
- El archivo seleccionado debe optimizarse/comprimirse antes de subir al storage.
- Valida que la imagen no exceda 5MB (muestra error si es mayor).

**Prioridad:** Must Have (1) | **Esfuerzo:** 5 | **Valor Negocio:** 85  
**Estado:** ⬜ Por Hacer | **Dependencias:** Ninguna | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Configuración OS Permisos** | Instalar `image_picker`, configurar strings de permisos nativos iOS/Android. | 0.5 h | Carlos |
| **2. UI Componente Modal** | Crear selector "Tomar Foto" o "Elegir Galería" estético y funcional. | 1.0 h | Carlos |
| **3. Upload (FormData/Multipart)** | Implementar la carga binaria hacia backend manejando bytes y barras de progreso. | 1.5 h | Carlos |

### US035 - Seguridad Biométrica (Huella / FaceID)
**Como** usuario  
**Deseo** proteger el acceso a mi aplicación mediante biometría  
**Para** mantener la privacidad absoluta de mis datos de salud.

**Criterios de Aceptación:**
- Opción configurable desde la pantalla de Ajustes.
- Si está activo, intercepta el regreso (onResume/foreground) de la app solicitando autenticación.
- Verifica huella/rostro usando APIs nativas del dispositivo. Si no soporta biometría, la opción se oculta.

**Prioridad:** Should Have (2) | **Esfuerzo:** 5 | **Valor Negocio:** 75  
**Estado:** ⬜ Por Hacer | **Dependencias:** Ninguna | **Sprint:** 4

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Permisos (local_auth)** | Configurar `USE_BIOMETRIC` y `NSFaceIDUsageDescription` en proyectos nativos. | 0.5 h | Carlos |
| **2. AppLifecycleObserver** | Detectar paso a foreground para lanzar prompt biométrico bloqueante en toda la app. | 1.5 h | Carlos |
| **3. Toggle Settings** | Añadir switch en perfil para encender/apagar protección guardada en almacenamiento local. | 0.5 h | Carlos |

---

### *Funcionalidades Descartadas (Out of Scope Mobile MVP)*
Las historias de administración avanzada desde consola web fueron eliminadas del alcance móvil para enfocarse exclusivamente en la experiencia del usuario final y entrenadores en app.
* **US005:** Ver el listado completo de usuarios registrados (Admin).
* **US006:** Asignar roles (entrenador/admin) a los miembros.
* **US007:** Bloquear o desbloquear cuentas de usuarios problemáticos.
* **US008:** Eliminar comentarios o artículos ofensivos en foros.

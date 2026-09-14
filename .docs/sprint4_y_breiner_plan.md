# Planificación de Historias de Usuario - Sprint 3 y Sprint 4

Este documento contiene la planificación optimizada de historias de usuario para el cierre del Sprint 3 y el inicio del Sprint 4.
Los tiempos (horas) han sido ajustados a la realidad de un desarrollo apoyado por agentes de IA.

## Sprint 3: Asignación para Breiner
*Enfoque del Sprint: Comunidad, Retos y Reportes.*

### US032 - Participación en Retos de la Comunidad
**Como** usuario registrado  
**Deseo** visualizar y unirme a los retos de la comunidad  
**Para** ganar puntos adicionales, insignias y mantenerme motivado junto a otros usuarios.

**Criterios de Aceptación:**
- Escenario principal: El usuario ve la lista de retos disponibles y al presionar "Unirse", su estado cambia a participante.
- Escenario alternativo: Si ya está unido, muestra su progreso actual en el reto.

**Prioridad:** Should Have (2)  
**Esfuerzo (Story Points):** 3  
**Valor de Negocio:** 70  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Maquetación UI de Retos** | Crear la pantalla principal de "Retos" (lista de tarjetas) y la vista de detalle del reto. Usar componentes reutilizables de la app para mantener el diseño limpio. | 2.0 h | Breiner |
| **2. Integración API Retos** | Configurar en `Dio` el consumo del endpoint `GET /api/v1/community/retos`. Crear el modelo `Reto` usando Freezed para parsear el JSON del backend. | 1.0 h | Breiner |
| **3. Lógica de Estado (Riverpod)** | Crear un `AsyncNotifierProvider` que maneje los estados de los retos (cargando, error, lista obtenida) y exponga un método `joinChallenge(id)` para unirse. | 1.5 h | Breiner |

---

## Sprint 4: Módulo de Entrenador (Coach)
*Enfoque del Sprint: Funcionalidades administrativas y de seguimiento para entrenadores.*

### US021 - Listado de Clientes del Entrenador
**Como** entrenador  
**Deseo** ver el listado de mis clientes asignados  
**Para** saber exactamente a quiénes debo hacer seguimiento y auditar.

**Criterios de Aceptación:**
- Escenario principal: El coach entra a su panel y ve la lista de sus pupilos activos.
- Escenario alternativo: Si no tiene clientes, se muestra un estado vacío amigable (empty state).

**Prioridad:** Must Have (1)  
**Esfuerzo (Story Points):** 3  
**Valor de Negocio:** 80  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI Panel Entrenador** | Diseñar el Dashboard exclusivo del rol "Coach", mostrando una tabla o lista de clientes activos con su información básica y estado general. | 2.0 h | Juan |
| **2. API Clientes Coach** | Integrar endpoint de obtención de clientes, definiendo los DTOs (Modelos) correspondientes y manejando correctamente el Bearer Token del Coach. | 1.0 h | Juan |
| **3. Gestión de Estado** | Implementar el Provider que traiga la lista de clientes, con soporte para "pull-to-refresh" para que el entrenador recargue los datos fácilmente. | 1.0 h | Juan |

### US022 - Creación de Rutinas Modelo
**Como** entrenador  
**Deseo** crear rutinas modelo agrupando varios hábitos  
**Para** organizar mis planes por objetivos específicos (ej. "Bajar de peso en 30 días") y reutilizarlos.

**Criterios de Aceptación:**
- Escenario principal: El entrenador guarda una rutina llamada "Bajar de peso en 30 días" y se refleja en su lista de rutinas creadas.
- Escenario alternativo: Si falta el nombre o no hay hábitos, el botón de guardar se deshabilita.

**Prioridad:** Must Have (1)  
**Esfuerzo (Story Points):** 5  
**Valor de Negocio:** 85  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Formulario Dinámico de Rutinas** | Maquetar un formulario donde el Coach pueda agregar un nombre de rutina y añadir dinámicamente "N" cantidad de hábitos a esa rutina antes de guardar. | 2.0 h | Juan |
| **2. Integración POST Rutinas** | Consumir el endpoint de creación de rutinas. Mapear los datos del formulario a un JSON anidado válido para enviar al backend. | 1.0 h | Juan |
| **3. Validaciones de Formulario** | Implementar validaciones en tiempo real (mínimo 1 hábito, nombre no vacío) usando el estado local o las utilidades de validación de Flutter. | 1.0 h | Juan |

### US023 - Asignación de Rutinas a Clientes
**Como** entrenador  
**Deseo** asignar una rutina prearmada a un cliente específico  
**Para** facilitarle el inicio en la plataforma sin que él tenga que crear los hábitos uno por uno.

**Criterios de Aceptación:**
- Escenario principal: El entrenador envía la rutina y al pupilo se le autollenan los hábitos en su cuenta sin errores.

**Prioridad:** Must Have (1)  
**Esfuerzo (Story Points):** 3  
**Valor de Negocio:** 90  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Modal/UI de Asignación** | Crear un BottomSheet o Dialog interactivo que permita seleccionar un cliente de una lista y elegir la rutina a asignarle desde un Dropdown. | 1.5 h | Nicolas |
| **2. API Asignar Rutina** | Conectar el botón de guardado con el endpoint de asignación, mostrando un SnackBar de éxito o el mensaje de error que devuelva la API. | 1.0 h | Nicolas |

### US024 - Visualización de Progreso del Cliente
**Como** entrenador  
**Deseo** ver el progreso diario y las estadísticas de mi cliente  
**Para** auditar su nivel de cumplimiento, felicitarlo o enviarle alertas si está fallando.

**Criterios de Aceptación:**
- Escenario principal: El coach accede al dashboard de solo lectura del cliente y puede ver qué días falló en la semana.

**Prioridad:** Should Have (2)  
**Esfuerzo (Story Points):** 3  
**Valor de Negocio:** 75  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. UI Reutilizable de Reportes** | Reutilizar la vista de `ReportsScreen` (o sus gráficas de `fl_chart`) pero inyectándole los datos del cliente en lugar de los datos propios, en modo solo lectura. | 2.0 h | Nicolas |
| **2. API Progreso Cliente** | Integrar el endpoint que trae las estadísticas específicas de un usuario (cliente), asegurando que el backend valide los permisos RLS. | 1.0 h | Nicolas |

---

## Sprint 4: Capacidades Nativas y Sensores
*Enfoque del Sprint: Aprovechar el hardware del dispositivo móvil para enriquecer la app.*

### US033 - Ubicación (GPS)
**Como** usuario  
**Deseo** utilizar mi ubicación geográfica  
**Para** descubrir entrenadores cercanos o registrar desde dónde he completado mis hábitos.

**Criterios de Aceptación:**
- Escenario principal: La app solicita permiso de ubicación; si se concede, registra las coordenadas exitosamente.
- Escenario alternativo: Si se deniega el permiso, la app sigue funcionando de manera normal sin bloquearse.

**Prioridad:** Could Have (3)  
**Esfuerzo (Story Points):** 3  
**Valor de Negocio:** 60  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Permisos e Instalación GPS** | Instalar `geolocator`. Configurar `AndroidManifest.xml` e `Info.plist` para solicitar permisos de ubicación al usuario de forma segura. | 1.0 h | Breiner |
| **2. Servicio de Geolocalización** | Crear una clase `LocationService` en Flutter que valide permisos, solicite activación de GPS y retorne Latitud/Longitud actuales. | 1.5 h | Breiner |

### US034 - Cámara, Galería y Archivos
**Como** usuario  
**Deseo** subir imágenes desde mi cámara/galería y adjuntar archivos  
**Para** actualizar mi foto de perfil y compartir documentos útiles en los foros de la comunidad.

**Criterios de Aceptación:**
- Escenario principal: El usuario selecciona o toma una foto y esta se sube y actualiza en su perfil o foro correctamente.
- Escenario alternativo: Si el archivo es demasiado grande o el formato no es soportado, se muestra un mensaje de error claro.

**Prioridad:** Must Have (1)  
**Esfuerzo (Story Points):** 5  
**Valor de Negocio:** 85  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Configuración de Permisos Multimedia** | Instalar `image_picker` y `file_picker`. Configurar los permisos nativos requeridos para acceso a cámara y almacenamiento en iOS/Android. | 1.0 h | Carlos |
| **2. UI Componente Selector de Medios** | Crear un BottomSheet reutilizable "Subir archivo" con tres opciones: Tomar Foto, Elegir de Galería, Subir Documento. | 1.5 h | Carlos |
| **3. Servicio Upload (FormData)** | Implementar la carga de archivos binarios hacia el backend o Supabase Storage usando `Dio` (Multipart/FormData), mostrando indicador de progreso. | 2.0 h | Carlos |

### US035 - Seguridad Biométrica (Huella / FaceID)
**Como** usuario  
**Deseo** proteger el acceso a mi aplicación mediante biometría  
**Para** mantener la privacidad absoluta de mis datos de salud, rutinas y progreso.

**Criterios de Aceptación:**
- Escenario principal: El usuario activa la opción; al volver a abrir la app desde segundo plano, el sistema nativo le pide su huella/rostro para continuar.
- Escenario alternativo: Si el dispositivo no tiene soporte biométrico, la opción se oculta en los ajustes de forma segura.

**Prioridad:** Should Have (2)  
**Esfuerzo (Story Points):** 5  
**Valor de Negocio:** 75  

| Tarea | Descripción Detallada | Esfuerzo Estimado | Responsable |
|-------|----------------------|-------------------|-------------|
| **1. Instalación y Permisos Biometría** | Instalar `local_auth`. Configurar permisos nativos (ej. `USE_BIOMETRIC` en Android y clave `NSFaceIDUsageDescription` en iOS). | 1.0 h | Carlos |
| **2. Listener de Ciclo de Vida (AppLifecycle)** | Implementar un observer que detecte cuando la app pasa a background y vuelve a foreground, forzando la pantalla de autenticación biométrica si está activa. | 2.0 h | Carlos |
| **3. Toggle de Seguridad en Ajustes** | Agregar un "Switch" en la pantalla de Ajustes de Perfil para activar/desactivar la protección biométrica, guardando el valor en `SecureStorage`. | 1.0 h | Carlos |

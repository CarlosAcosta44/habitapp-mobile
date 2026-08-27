# Arquitectura Base y Convenciones (Clean Pragmatic)

Para el desarrollo del frontend de HabitApp con el equipo de 4 desarrolladores, adoptaremos una **Clean Architecture Pragmática basada en "Feature-First" (Orientada a Funcionalidades)** impulsada por **Riverpod**.

Este documento es una guía obligatoria tanto para los desarrolladores como para cualquier agente de IA (como Antigravity) que genere código para este proyecto.

## 1. Patrón Arquitectónico
Dado que toda la validación y base de datos viven en un backend independiente (NestJS), nuestra App de Flutter es un **Thin Client**. 
Por lo tanto, **NO usaremos una Clean Architecture estricta de 5 capas (con Casos de Uso aislados)** porque generaría demasiado "boilerplate". Usaremos un enfoque de **3 capas por funcionalidad**.

## 2. Estructura de Carpetas (Tree)
Todo el desarrollo ocurrirá dentro de la carpeta `lib/` bajo la siguiente estructura estricta:

```text
lib/
 ┣ core/                     # Código transversal compartido en toda la app
 ┃ ┣ constants/              # URLs base, claves de storage
 ┃ ┣ network/                # Configuración de Dio y AuthInterceptor
 ┃ ┣ router/                 # Configuración de GoRouter
 ┃ ┣ theme/                  # Paleta de colores y estilos globales
 ┃ ┗ widgets/                # Widgets genéricos (CustomButton, CustomInput)
 ┃
 ┣ features/                 # Módulos separados por Dominio de Negocio
 ┃ ┣ auth/                   # Todo lo relacionado a login, registro, sesión
 ┃ ┃ ┣ data/                 # Capa de Datos (Modelos y Repositorios)
 ┃ ┃ ┣ providers/            # Capa de Estado (Notifiers de Riverpod)
 ┃ ┃ ┗ presentation/         # Capa Visual (Screens y Widgets específicos)
 ┃ ┃
 ┃ ┣ habits/                 # Dashboard y seguimiento de hábitos diarios
 ┃ ┃ ┣ data/                 
 ┃ ┃ ┣ providers/            
 ┃ ┃ ┗ presentation/         
 ┃ ┃
 ┃ ┣ community/              # Módulo de posts, comentarios y retos
 ┃ ┗ profile/                # Módulo de ajustes, ranking y estadísticas
 ┃
 ┗ main.dart                 # Punto de entrada (Configuración de ProviderScope)
```

## 3. Desglose de las 3 Capas (Dentro de cada Feature)

### Capa 1: Data (`data/`)
*   **Modelos (`models/`):** Clases inmutables creadas con `freezed` que representan la data enviada por NestJS.
*   **Repositorios (`repositories/`):** Clases que contienen la lógica para realizar las peticiones HTTP (utilizando la instancia de `Dio` inyectada). **Toda comunicación con NestJS ocurre aquí.**

### Capa 2: Estado (`providers/` o `controllers/`)
*   **Notifiers (Riverpod):** Reemplazan a los tradicionales *Casos de Uso*. Son clases que extienden de `AsyncNotifier` o `StateNotifier`. 
*   **Responsabilidad:** Llaman a los métodos del Repositorio, procesan la respuesta y actualizan el estado de la UI (ej. pasar de "cargando" a "data" o "error").
*   *Ejemplo:* `HabitsNotifier` llama a `habitRepository.getTodayHabits()` y expone la lista a la vista.

### Capa 3: Presentación (`presentation/`)
*   **Screens (`screens/`):** Pantallas enteras a las que el usuario navega vía GoRouter. Heredan de `ConsumerWidget` para poder leer los providers.
*   **Widgets (`widgets/`):** Componentes visuales que solo pertenecen a esta funcionalidad (ej. un `HabitCard` no va en `core/widgets`, va en `features/habits/presentation/widgets/`).
*   **Responsabilidad:** La UI **nunca** debe llamar al Repositorio o hacer peticiones HTTP directamente. La UI solo lee el estado del Provider o invoca sus métodos (ej. `ref.read(habitsProvider.notifier).checkHabit()`).

## 4. Reglas Críticas para Devs y Agentes (Code Review)
1. **No mezclar dominios:** La funcionalidad de Autenticación no debe acceder directamente al repositorio de Hábitos. Si necesitan comunicarse, se hace a través de Providers globales o en la capa de presentación.
2. **Evitar setState() para lógica de negocio:** Utilizar siempre Riverpod para manejo de estados complejos. `setState` queda restringido solo a estados efímeros puramente visuales (ej. animaciones simples).
3. **Cero lógica en UI:** Si un botón desencadena 5 acciones matemáticas antes de guardar, esas operaciones van en el Notifier de Riverpod, no en el método `onPressed` del Widget.

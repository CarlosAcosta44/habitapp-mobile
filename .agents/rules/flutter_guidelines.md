# Reglas de Desarrollo Flutter (HabitApp Móvil)

Estas reglas definen el comportamiento de cualquier agente de IA al generar o editar código para la aplicación móvil HabitApp. **Deben seguirse estrictamente en todo momento.**

## 1. Arquitectura (Clean Pragmática / Feature-First)
- El proyecto usa una estructura orientada a funcionalidades. Todo código nuevo debe colocarse en `lib/features/<nombre_feature>/`.
- Cada feature se divide estrictamente en 3 subcarpetas:
  1. `data/`: Modelos de datos y Repositorios (llamadas HTTP).
  2. `providers/`: Notifiers de Riverpod que manejan el estado y llaman al repositorio.
  3. `presentation/`: Screens (pantallas enteras) y Widgets (componentes específicos).
- **REGLA CRÍTICA:** La capa de `presentation` NUNCA debe importar ni llamar directamente a los repositorios o usar `Dio`. La UI solo debe leer el estado y llamar métodos de los `providers`.
- **REGLA CRÍTICA:** Cero lógica de negocio (matemáticas complejas, validación de red) dentro de un Widget o en los callbacks `onPressed`. Toda lógica pertenece al Provider.

## 2. Gestión de Estado e Inyección (Riverpod)
- Usar **Riverpod** (`flutter_riverpod`, `riverpod_annotation`) para TODO el manejo de estado e inyección de dependencias.
- No usar `Provider`, `GetX`, `BLoC` ni instanciar clases globalmente.
- Privilegiar el uso de Providers generados por código (`@riverpod`).
- Las pantallas deben heredar de `ConsumerWidget` o `ConsumerStatefulWidget`.

## 3. Redes y API (Dio)
- Usar **Dio** para todas las peticiones HTTP. No usar `http`.
- Asumir que existe un interceptor (`AuthInterceptor`) que inyecta automáticamente el JWT (`Bearer token`), por lo que no es necesario pasar el token en cada petición privada.

## 4. Enrutamiento (GoRouter)
- Usar **GoRouter** para toda la navegación.
- NO usar `Navigator.of(context).push(...)`. Usar `context.goNamed(...)` o `context.pushNamed(...)`.

## 5. Modelado de Datos (Freezed)
- Todos los modelos de respuesta de API deben crearse usando **Freezed** (`@freezed`) y **JSON Serializable** (`@JsonSerializable()`).
- No escribir métodos `fromJson` o `toJson` manualmente a menos que sea una serialización muy particular.

## 6. Estándares Generales
- Todo el código debe tener *Null Safety* habilitado.
- Utilizar componentes base de la carpeta `lib/core/widgets/` cuando sea posible (ej. botones genéricos) en lugar de crear botones desde cero.

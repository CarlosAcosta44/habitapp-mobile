# Convenciones de Código y Git

## 1. Convenciones Git (Conventional Commits)
Todo mensaje de commit debe seguir la siguiente estructura:
`tipo(contexto opcional): descripción breve`

- `feat:` Una nueva característica.
- `fix:` Arreglo de un bug.
- `docs:` Cambios solo en documentación.
- `style:` Cambios visuales de formato (espacios, comas, etc) que no afectan el código.
- `refactor:` Refactorización de código.
- `test:` Agregar o modificar pruebas.
- `chore:` Actualización de dependencias o configuraciones.

## 2. Convenciones de Flutter / Dart
- **Clases y Tipos:** `PascalCase` (ej. `HabitRepository`).
- **Archivos y Carpetas:** `snake_case` (ej. `habit_card.dart`).
- **Variables y Funciones:** `camelCase` (ej. `fetchHabits()`).
- **Inmutabilidad:** Usar `const` en todos los widgets que no dependan de estado externo.
- **Null Safety:** Obligatorio el manejo correcto de nulos, evitar el uso excesivo del operador `!`.

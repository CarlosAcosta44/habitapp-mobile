# Guía de Flujo de Trabajo con Git

Para mantener el código ordenado y evitar conflictos catastróficos, todo el equipo (Carlos, Breiner, Nicolas y Juan) debe seguir estas reglas. Nuestro sistema de CI/CD y los Agentes de IA también las validan rigurosamente.

## 1. Ramas (Gitflow)
- No trabajes nunca directamente en `main` o `develop`.
- Crea una rama para tu tarea: `git checkout -b feature/nombre-de-tarea` (siempre desde `develop`).
- Nombres de rama permitidos: `feature/*`, `bugfix/*`, `hotfix/*`.
- Una vez termines, sube la rama y **abre un Pull Request** en Azure DevOps hacia `develop`. Nunca hagas merge directo.

## 2. Commits Semánticos
Tus mensajes de commit deben explicar **qué** hace el commit.
Ejemplo de formato: `tipo(scope opcional): mensaje corto` -> `feat(auth): agregar pantalla de splash screen`

- `feat:` Nuevas pantallas, componentes, modelos o lógica de negocio.
- `fix:` Solución a un bug o crash en la app.
- `docs:` Modificar archivos `.md` u otra documentación.
- `refactor:` Mejorar código existente sin cambiar su funcionamiento aparente.
- `chore:` Actualizar dependencias (`pubspec.yaml`), configuraciones o `build_runner`.

## 3. Versionamiento Semántico (SemVer)
La versión de la app en `pubspec.yaml` usa el formato `X.Y.Z` (ej. `1.0.4`):
- **X (Mayor):** Cambios gigantes (V2 de la app, rediseño total, rompimiento de compatibilidad).
- **Y (Menor):** Nuevas funcionalidades completas (Ej. Módulo de Comunidad).
- **Z (Parche):** Arreglos rápidos de bugs o ajustes menores visuales.

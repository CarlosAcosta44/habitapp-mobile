---
description: Reglas estrictas de Git, Gitflow y versionamiento para agentes
---

# Git Guidelines

Todos los agentes de IA (incluyendo Antigravity) y desarrolladores deben seguir estrictamente estas reglas al interactuar con los repositorios de este proyecto.

## 1. Gitflow
*   **main**: Contiene el código de producción. Solo recibe merges desde `develop` o ramas de hotfix.
*   **develop**: Rama principal de integración. Todo el código de desarrollo se fusiona aquí.
*   **feature/***: Ramas para nuevas funcionalidades. Se crean desde `develop` (ej. `feature/splash-screen`).
*   **bugfix/***: Ramas para arreglar errores no críticos en desarrollo. Se crean desde `develop`.
*   **hotfix/***: Ramas para errores críticos en producción. Se crean desde `main`.

## 2. Commits Semánticos
Usa obligatoriamente los siguientes prefijos convencionales:
*   `feat:` Nueva característica o funcionalidad.
*   `fix:` Corrección de errores.
*   `docs:` Cambios solo en documentación.
*   `style:` Cambios que no afectan el significado del código (espacios, formato, punto y coma, etc).
*   `refactor:` Un cambio de código que no corrige un error ni añade una característica.
*   `perf:` Un cambio de código que mejora el rendimiento.
*   `test:` Añadir pruebas faltantes o corregir pruebas existentes.
*   `chore:` Cambios en el proceso de construcción (build) o herramientas auxiliares.

## 3. Semantic Versioning (SemVer)
Sigue el patrón `MAYOR.MENOR.PARCHE` (ej. `1.2.3`):
*   **MAYOR:** Cuando se realizan cambios incompatibles o drásticos.
*   **MENOR:** Cuando se añade funcionalidad de forma compatible con versiones anteriores.
*   **PARCHE:** Cuando se realizan correcciones de errores compatibles con versiones anteriores.

# Arquitectura Técnica

El frontend móvil de HabitApp utiliza **Flutter** y sigue una **Clean Architecture Pragmática (Feature-First)**.

## Stack Tecnológico Core
- **Framework:** Flutter (Dart)
- **Estado e Inyección:** Riverpod
- **Redes HTTP:** Dio (con interceptores)
- **Navegación:** GoRouter
- **Modelos:** Freezed + Json Serializable

## Estructura de Carpetas Obligatoria
```text
lib/
 ┣ core/                     # Código transversal (theme, red, router)
 ┗ features/                 # Módulos separados por Dominio de Negocio
    ┣ auth/                  # Capas: data, providers, presentation
    ┗ habits/                # Capas: data, providers, presentation
```

*Para detalles exhaustivos, consultar los documentos `arquitectura_base.md` y `stack_tecnologico.md` en el repositorio frontend.*

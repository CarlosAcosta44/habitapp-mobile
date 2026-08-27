# Contexto del Proyecto: HabitApp

## 1. Visión General
**HabitApp** es una plataforma integral de seguimiento de hábitos, gamificación y comunidad. Su objetivo es ayudar a los usuarios a construir rutinas saludables mediante el seguimiento diario, la motivación a través de rachas y puntos, y el apoyo social mediante entrenadores y una comunidad activa.

## 2. Arquitectura Global del Sistema
El proyecto ha evolucionado hacia una arquitectura moderna, escalable y separada en capas claras:

*   **Backend (API RESTful):** Construido con **NestJS**. Actúa como la fuente única de la verdad, encapsulando toda la lógica de negocio, validaciones y reglas de seguridad. 
    *   **Base de Datos:** PostgreSQL (alojado en Supabase, usado como base de datos pura).
    *   **Autenticación:** Sistema propio basado en **JWT (JSON Web Tokens)** implementado en NestJS, soportando login local y OAuth.
*   **Frontend Web:** Construido con **Next.js**. Capa puramente de presentación para usuarios de escritorio.
*   **Frontend Móvil (Foco Actual):** Construido con **Flutter**. Será la interfaz principal para el usuario final (B2C). Está diseñado usando una **Arquitectura Limpia Pragmática (Feature-First)** impulsada por **Riverpod** para la gestión de estado e inyección de dependencias.

## 3. Estado Actual del Proyecto
*   **Backend:** ~95% completado. Listo para ser consumido por cualquier cliente (Web o Móvil). Todo está expuesto bajo `http://localhost:4000/api`.
*   **Frontend Móvil (Flutter):** Fase de inicio (Sprint 0). Los repositorios en Azure DevOps están configurados y los diseños de las 10 pantallas principales están listos. Se ha acordado el Stack Tecnológico y la Arquitectura a seguir.

## 4. Equipo de Desarrollo Móvil
1.  **Carlos Acosta**
2.  **Breiner Rodriguez**
3.  **Nicolas Crispoca**
4.  **Juan Diaz**

## 5. Metodología de Trabajo
*   **Gestión:** Azure Boards (Scrum) y Azure Repos.
*   **Sprints:** 3 Sprints intensivos y paralelos. Todo el equipo aporta a cada módulo simultáneamente dividiendo el trabajo por capas (Data, Providers, UI).
*   **Documentación Relacionada:** 
    *   [stack_tecnologico.md](./stack_tecnologico.md) - Herramientas a utilizar.
    *   [arquitectura_base.md](./arquitectura_base.md) - Estructura de carpetas y estándares de código.
    *   [planeacion_movil.md](./planeacion_movil.md) - Definición de los Sprints y tareas.

# Registro de Decisiones Técnicas (ADR)

Este documento mantiene un historial de las decisiones arquitectónicas clave tomadas durante el proyecto HabitApp.

## ADR 001: Elección de Riverpod vs BLoC
- **Fecha:** Agosto 2026
- **Contexto:** Se necesitaba un gestor de estado para el equipo de 4 personas.
- **Decisión:** Se eligió Riverpod (`flutter_riverpod`) en lugar de BLoC clásico.
- **Justificación:** Reduce el boilerplate, ofrece inyección de dependencias nativa y detecta errores en tiempo de compilación. Permite usar una "Clean Architecture Pragmática" más ágil.

## ADR 002: Separación estricta de Backend y Frontend
- **Fecha:** Agosto 2026
- **Contexto:** Definición de acceso a base de datos (Supabase).
- **Decisión:** El Frontend Móvil NO se conectará directamente a Supabase. Se conectará a un Backend en NestJS.
- **Justificación:** Centralizar las reglas de negocio, cálculos de gamificación y seguridad (JWT/RLS) en un solo lugar.

# Design Tokens (HabitApp)

Este documento define la estructura de diseño (Design System) extraída de Figma. Los desarrolladores deben mapear estos tokens a la configuración de Flutter dentro de la carpeta `lib/core/theme/`.

## 1. Tipografía (Text Styles)
*(Nota: El formato es Tamaño / Altura de línea, ej: 48/56)*

**Headline (Cabeceras):**
- **H1:** Bold - 48 / 56
- **H2:** Bold - 40 / 48
- **H3:** Bold - 36 / 40
- **H4:** Bold - 32 / 40
- **H5:** Bold - 24 / 32
- **H6:** Medium - 20 / 24

**Body (Cuerpo de texto):**
- **Title:** Medium - 18 / 24
- **Paragraph (Book):** Book (Regular) - 14 / 20
- **Paragraph (Medium):** Medium - 14 / 20
- **Alternative:** Book (Regular) - 12 / 16
- **CHIP:** Bold - 12 / 16

---

## 2. Paleta de Colores (Color Styles)
*(Nota: Todos los colores tienen una escala del 100 al 10, que indica variaciones de saturación u opacidad. El desarrollador de UI debe extraer el HEX de Figma al maquetar).*

**Colores Base:**
- Black
- White
- Background

**Colores Principales (Primary):**
- **Black:** Escala 100 al 10
- **Blue:** Escala 100 al 10 *(Color principal de la marca)*

**Colores Semánticos / Estado:**
- **Blue (Info):** Escala 100 al 10
- **Red (Error):** Escala 100 al 10
- **Orange (Warning):** Escala 100 al 10
- **Green (Success):** Escala 100 al 10

**Colores Secundarios (Ideales para etiquetas, retos y gamificación):**
- **Orange:** Escala 100 al 10
- **Purple:** Escala 100 al 10
- **Pink:** Escala 100 al 10
- **Teal:** Escala 100 al 10
- **Yellow:** Escala 100 al 10
- **Dark Blue:** Escala 100 al 10

**Gradientes:**
- Blue (Degradado principal)

---

## 3. Sombras y Efectos (Effect Styles)
- **Box Shadow:** (Sombra amplia, ideal para tarjetas o modales).
- **Medium Shadow:** (Sombra intermedia para cards secundarias).
- **Small Shadow:** (Sombra ligera, ideal para botones desplegables o inputs).

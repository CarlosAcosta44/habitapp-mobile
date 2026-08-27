# Guía de Configuración del Entorno

Sigue estos pasos para correr el frontend móvil de HabitApp por primera vez.

## Requisitos Previos
1. **Flutter SDK** instalado (versión 3.x+). Ejecuta `flutter doctor` para verificar.
2. **Android Studio** o Xcode instalados para emuladores.
3. El **Backend de NestJS** debe estar corriendo localmente (puerto 4000).

## Pasos de Instalación
1. Clonar el repositorio `HabitAppFrontend`:
   ```bash
   git clone <URL_AZURE>
   cd HabitAppFrontend
   ```
2. Instalar dependencias:
   ```bash
   flutter pub get
   ```
3. Generar archivos de código (para Freezed y Riverpod):
   ```bash
   dart run build_runner build -d
   ```
4. Configurar variables de entorno:
   Copiar `.env.example` a `.env` y configurar la URL base de NestJS:
   ```env
   API_BASE_URL=http://localhost:4000/api/v1
   ```
5. Ejecutar la app:
   ```bash
   flutter run
   ```

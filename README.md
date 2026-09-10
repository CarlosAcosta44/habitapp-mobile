# HabitApp Frontend 📱

Este es el repositorio del frontend de **HabitApp**, una aplicación construida con Flutter y Riverpod para el seguimiento de hábitos, comunidad y reportes detallados.

---

## 🚀 Requisitos Previos

Para empezar a desarrollar en tu máquina local o en otro entorno, asegúrate de tener instalado:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión estable más reciente).
- [Dart SDK](https://dart.dev/get-dart) (se incluye con Flutter).
- Un editor de código como VS Code o Android Studio.
- (Opcional pero recomendado) Emulador de Android o simulador de iOS.

---

## 🛠️ Instalación y Configuración

Sigue estos pasos para arrancar el proyecto desde cero:

### 1. Clonar e instalar dependencias
Clona este repositorio en tu máquina y descarga los paquetes de pub:
```bash
git clone <URL_DEL_REPOSITORIO>
cd HabitAppFrontend
flutter pub get
```

### 2. Variables de Entorno (Codespaces / Backend Local)
HabitApp se comunica con un backend (NestJS). Debes indicarle a la app dónde encontrar dicho backend.

**Paso A: Crear el archivo `.env`**
En la raíz del proyecto (`HabitAppFrontend/`), crea un archivo llamado `.env` e incluye tu URL:
```env
API_URL=https://tu-backend-url.com/api/v1
```

**Paso B: Actualizar según tu entorno**
Gracias al paquete `flutter_dotenv`, la aplicación leerá la URL automáticamente desde el archivo `.env`. 

Si usas un **Codespace de GitHub**, recuerda que cada vez que el Codespace del backend se reinicia o se crea uno nuevo, la URL del puerto expuesto cambia (ej. `https://silver-chainsaw-...-4000.app.github.dev/api/v1`). 
**Solo debes actualizar esa URL en el archivo `.env`**; el resto de la app, incluyendo `dio_client.dart`, se adaptará automáticamente a la nueva ruta.

### 3. Configuración de Firebase (Notificaciones)
Este proyecto utiliza Firebase Cloud Messaging para las notificaciones push y reportes. Debes vincular tu entorno local al proyecto de Firebase:

1. Instala las herramientas de Firebase:
   ```bash
   npm install -g firebase-tools
   ```
2. Inicia sesión en Firebase:
   ```bash
   firebase login
   ```
3. Activa FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   *(Si el sistema te advierte sobre tu PATH, puedes ejecutar el siguiente paso con `~/.pub-cache/bin/flutterfire configure`)*.
4. Vincula el proyecto:
   ```bash
   flutterfire configure
   ```
   - Selecciona el proyecto **HabitApp**.
   - Deja marcadas las plataformas Android e iOS.
   - Si te pregunta si quieres sobrescribir `lib/firebase_options.dart`, dile que **Sí**.

---

## ▶️ Ejecutar la Aplicación

Con las dependencias instaladas y configuradas, puedes correr el proyecto:

```bash
flutter run
```

O simplemente presionar `F5` si estás usando VS Code.

---

## 🏗️ Arquitectura y Tecnologías
- **Framework:** Flutter
- **Estado:** Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Navegación:** GoRouter
- **Red:** Dio (con interceptores para Auth y tokens seguros)
- **Almacenamiento Local:** Flutter Secure Storage
- **Gráficas y Reportes:** `fl_chart`, `pdf`, `path_provider`
- **Notificaciones:** `firebase_messaging`, `flutter_local_notifications`

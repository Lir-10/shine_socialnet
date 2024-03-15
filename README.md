
# Shine Social App

Una pequeña red social creada con Flutter y Firebase.




## Features

- Autenticación: Iniciar sesión por correo electrónico / Cerrar sesión / Registrarse
- Publicar mensaje en el muro
- Dar "Me gusta" a una publicación
- Comentar una publicación
- Página de perfil que muestra las publicaciones del usuario
## Requerimientos Previos

- Visual Studio Code
- Android Studio
- Flutter SDK
## Instalacion local

Clonar el repositorio

```bash
  git clone -b v1.2 https://github.com/Lir-10/shine_socialnet
  cd shine_socialnet
```
 Instalar FlutterFire
 ``` bash
 npm install -g firebase-tools
```
Activar FlutterFire
```
dart pub global activate flutterfire_cli
```
Agregar dependencias necesarias
``` bash
flutter pub add firebase_core

flutter pub add firebase_auth

flutter pub add cloud_firestore

flutter pub add intl
```
Ir a la [Consola Firebase](https://console.firebase.google.com/) y crear un nuevo proyecto. Una vez creado el proyecto ejecutar el siguiente comando en terminal:
```bash
firebase login
```
Corrobore el haber iniciado sesión con el mismo correo electrónico que su consola Firebase. Luego active el cli escribiendo:
``` bash
dart pub global activate flutterfire_cli
```
Luego, finalmente escriba el siguiente comando para elegir su proyecto:
```bash
flutterfire configure
```
En la consola de Firebase, vaya a autenticación y habilite el proveedor de correo electrónico.

En la consola de Firebase, vaya a la base de datos de Firestore y cree una nueva base de datos. Asegúrate de ir a las reglas y cambiar la regla de "escritura" de "falso" a "verdadero".




## Deployment

Para lanzar este proyecto ejecuta el siguiente comando en la terminal
```bash
  flutter run -[dispositivo]
```
## Documentacion

- [Instalacion Flutter](https://docs.flutter.dev/get-started/install)
- [Documentacion Flutter](https://docs.flutter.dev/)
- [Instalacion Firebase](https://console.firebase.google.com/u/0/)
- [Descarga Visual Studio Code](https://code.visualstudio.com/download)
- [Descarga Android Studio](https://developer.android.com/studio)
## Autores

- [@Efrain180](https://github.com/Efrain180)
- [@Lir-10](https://github.com/Lir-10)
- [Jose Alexander Garcia](https://github.com/papiyeison)
- Fidela Ramirez

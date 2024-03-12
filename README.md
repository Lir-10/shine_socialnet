Shine_Social _App

1. Instalar FLutter Fire

npm install -g firebase-tools

activar flutter fire

dart pub global activate flutterfire_cli

2. Agregar Dependencias Necesarias

flutter pub add firebase_core

flutter pub add firebase_auth

flutter pub add cloud_firestore

flutter pub add intl

3.Ir a la consola Firebase y crear un nuevo proyecto (https://console.firebase.google.com/).

Escribir en la terminal

firebase login

Make sure it's logged in with the same email as your firebase console. Then activate the cli by typing:

dart pub global activate flutterfire_cli

Then finally type the following command to pick your project:

flutterfire configure

4. In your firebase console, go to authentication and enable the email provider.

5. In your firebase console, go to firestore database and create a new database. Make sure to go to the rules and change the 'write' rule from 'false' to 'true'

// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3VCfzEIjZcgmrJ75I4UggWsQTM64d5vo',
    appId: '1:134611428258:web:219faf50861f0fc67188fb',
    messagingSenderId: '134611428258',
    projectId: 'socialnetwork-3e670',
    authDomain: 'socialnetwork-3e670.firebaseapp.com',
    storageBucket: 'socialnetwork-3e670.appspot.com',
    measurementId: 'G-KTBKN1GL8Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSbgI5ErphAnVYQoPn2mxMhnrz-ceRcwk',
    appId: '1:134611428258:android:854493647f41e0ca7188fb',
    messagingSenderId: '134611428258',
    projectId: 'socialnetwork-3e670',
    storageBucket: 'socialnetwork-3e670.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3NdkxZ56Br-WRuWuGV_5B4e460HIfIR8',
    appId: '1:134611428258:ios:0e2cdb9953ea8db97188fb',
    messagingSenderId: '134611428258',
    projectId: 'socialnetwork-3e670',
    storageBucket: 'socialnetwork-3e670.appspot.com',
    iosBundleId: 'com.example.theWall',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3NdkxZ56Br-WRuWuGV_5B4e460HIfIR8',
    appId: '1:134611428258:ios:0e2cdb9953ea8db97188fb',
    messagingSenderId: '134611428258',
    projectId: 'socialnetwork-3e670',
    storageBucket: 'socialnetwork-3e670.appspot.com',
    iosBundleId: 'com.example.theWall',
  );
}

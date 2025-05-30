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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBiAWrtFbE-u2iMzH_0aftxgjJHT8qYVmQ',
    appId: '1:762432045224:web:e6cf6a004b187aa9f4429d',
    messagingSenderId: '762432045224',
    projectId: 'souldate-5d68c',
    authDomain: 'souldate-5d68c.firebaseapp.com',
    databaseURL: 'https://souldate-5d68c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'souldate-5d68c.appspot.com',
    measurementId: 'G-7DBLM7HTD2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4xDY1oFUhwju0I_Ahv2zAdVcn6zy8pKo',
    appId: '1:762432045224:android:f37d1e94afb783f0f4429d',
    messagingSenderId: '762432045224',
    projectId: 'souldate-5d68c',
    databaseURL: 'https://souldate-5d68c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'souldate-5d68c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3DAtVUdxHGd0YWNVPsrId13Zh1D8tW14',
    appId: '1:762432045224:ios:3eb02c85748615bdf4429d',
    messagingSenderId: '762432045224',
    projectId: 'souldate-5d68c',
    databaseURL: 'https://souldate-5d68c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'souldate-5d68c.appspot.com',
    androidClientId: '762432045224-5s8nmq6cgt0cnvsabdsb9mp8l755ahq4.apps.googleusercontent.com',
    iosClientId: '762432045224-kqjk638ft09js9mpqkm0jmjt22vpqomb.apps.googleusercontent.com',
    iosBundleId: 'com.central.souldate',
  );
}

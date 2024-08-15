// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBUTFyvyWOe1QjENJNhjA8OfN7XhvWmRP8',
    appId: '1:858678269731:web:c3cfe6760965d5b2911e96',
    messagingSenderId: '858678269731',
    projectId: 'rentify-yash',
    authDomain: 'rentify-yash.firebaseapp.com',
    storageBucket: 'rentify-yash.appspot.com',
    measurementId: 'G-V047QYK6YM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiWclkhwLUkRmWplz6ZOwUacgQ_s2aG1U',
    appId: '1:858678269731:android:ad88b67f22889ebc911e96',
    messagingSenderId: '858678269731',
    projectId: 'rentify-yash',
    storageBucket: 'rentify-yash.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACjknj2CStMMSMlFvQoRQA-cCHzLag_pU',
    appId: '1:858678269731:ios:8d95b5a0505125ac911e96',
    messagingSenderId: '858678269731',
    projectId: 'rentify-yash',
    storageBucket: 'rentify-yash.appspot.com',
    iosBundleId: 'com.example.rentify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACjknj2CStMMSMlFvQoRQA-cCHzLag_pU',
    appId: '1:858678269731:ios:8d95b5a0505125ac911e96',
    messagingSenderId: '858678269731',
    projectId: 'rentify-yash',
    storageBucket: 'rentify-yash.appspot.com',
    iosBundleId: 'com.example.rentify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBUTFyvyWOe1QjENJNhjA8OfN7XhvWmRP8',
    appId: '1:858678269731:web:12da24bf97d925b1911e96',
    messagingSenderId: '858678269731',
    projectId: 'rentify-yash',
    authDomain: 'rentify-yash.firebaseapp.com',
    storageBucket: 'rentify-yash.appspot.com',
    measurementId: 'G-WZ1HRZ8KGZ',
  );
}
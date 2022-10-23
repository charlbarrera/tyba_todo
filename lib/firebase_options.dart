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
    apiKey: 'AIzaSyA6wThFDKZQ6wmvDkX-QbgaURZWVpKL4DM',
    appId: '1:91020317837:web:8a064de6d6524510',
    messagingSenderId: '91020317837',
    projectId: 'fir-test-e4ba6',
    authDomain: 'fir-test-e4ba6.firebaseapp.com',
    databaseURL: 'https://fir-test-e4ba6.firebaseio.com',
    storageBucket: 'fir-test-e4ba6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC37k0d7BHk4DtZtFqm3aUkrcPN2fkd2Bk',
    appId: '1:91020317837:android:0ab840eb3c8cb9d146bec4',
    messagingSenderId: '91020317837',
    projectId: 'fir-test-e4ba6',
    databaseURL: 'https://fir-test-e4ba6.firebaseio.com',
    storageBucket: 'fir-test-e4ba6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeX4Ub8HpDJzsz7tCdsWf7KQmEDobJb5w',
    appId: '1:91020317837:ios:a2902e6a5d3fd69446bec4',
    messagingSenderId: '91020317837',
    projectId: 'fir-test-e4ba6',
    databaseURL: 'https://fir-test-e4ba6.firebaseio.com',
    storageBucket: 'fir-test-e4ba6.appspot.com',
    iosClientId: '91020317837-d3tbvlgtb1008a0clt1mpjkmtca3nkce.apps.googleusercontent.com',
    iosBundleId: 'com.example.tybaTodo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAeX4Ub8HpDJzsz7tCdsWf7KQmEDobJb5w',
    appId: '1:91020317837:ios:a2902e6a5d3fd69446bec4',
    messagingSenderId: '91020317837',
    projectId: 'fir-test-e4ba6',
    databaseURL: 'https://fir-test-e4ba6.firebaseio.com',
    storageBucket: 'fir-test-e4ba6.appspot.com',
    iosClientId: '91020317837-d3tbvlgtb1008a0clt1mpjkmtca3nkce.apps.googleusercontent.com',
    iosBundleId: 'com.example.tybaTodo',
  );
}

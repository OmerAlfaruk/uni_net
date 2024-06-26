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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhDKDKCsz6xe_eHXe5rzzf9wX53KrLhCA',
    appId: '1:162037507829:android:a45771c79ca427102d47bc',
    messagingSenderId: '162037507829',
    projectId: 'unilink-e1cd3',
    storageBucket: 'unilink-e1cd3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvnLbis2Cdt6lrDof7pDSUJgi3Bqy-Kq4',
    appId: '1:162037507829:ios:7228a5751819207d2d47bc',
    messagingSenderId: '162037507829',
    projectId: 'unilink-e1cd3',
    storageBucket: 'unilink-e1cd3.appspot.com',
    iosBundleId: 'com.example.uniLink',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUkOQnP5CmNtC2sjIGSCpeyZwYrmjS8vk',
    appId: '1:162037507829:web:e7589713d0b018de2d47bc',
    messagingSenderId: '162037507829',
    projectId: 'unilink-e1cd3',
    authDomain: 'unilink-e1cd3.firebaseapp.com',
    storageBucket: 'unilink-e1cd3.appspot.com',
    measurementId: 'G-5RSPR7HPFW',
  );

}
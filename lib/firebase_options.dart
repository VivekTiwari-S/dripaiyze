
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
    apiKey: 'AIzaSyD3YqzaDQ3dcRIbVZ79mBdEOSOA24CqHDk',
    appId: '1:647218935783:web:783a5eaf5c92fb63ffef42',
    messagingSenderId: '647218935783',
    projectId: 'flutter-app-2d88a',
    authDomain: 'flutter-app-2d88a.firebaseapp.com',
    storageBucket: 'flutter-app-2d88a.firebasestorage.app',
    measurementId: 'G-0KP88JJSM5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCJySY1aaM13u_sCQgiLuoKafzMRRUpsM',
    appId: '1:647218935783:android:e6925b61d181de86ffef42',
    messagingSenderId: '647218935783',
    projectId: 'flutter-app-2d88a',
    storageBucket: 'flutter-app-2d88a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCASNSeYXoZzAf2DL3qk2M8zDbULJrnMkE',
    appId: '1:647218935783:ios:a0ee3ac38342c439ffef42',
    messagingSenderId: '647218935783',
    projectId: 'flutter-app-2d88a',
    storageBucket: 'flutter-app-2d88a.firebasestorage.app',
    iosBundleId: 'com.example.aquaminder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCASNSeYXoZzAf2DL3qk2M8zDbULJrnMkE',
    appId: '1:647218935783:ios:a0ee3ac38342c439ffef42',
    messagingSenderId: '647218935783',
    projectId: 'flutter-app-2d88a',
    storageBucket: 'flutter-app-2d88a.firebasestorage.app',
    iosBundleId: 'com.example.aquaminder',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3YqzaDQ3dcRIbVZ79mBdEOSOA24CqHDk',
    appId: '1:647218935783:web:b46000fafaf666caffef42',
    messagingSenderId: '647218935783',
    projectId: 'flutter-app-2d88a',
    authDomain: 'flutter-app-2d88a.firebaseapp.com',
    storageBucket: 'flutter-app-2d88a.firebasestorage.app',
    measurementId: 'G-358S3CN1WZ',
  );
}

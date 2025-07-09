
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyBFoXgqd0CbmPV95SZqlMw3Uar_pD_zAQM',
    appId: '1:606858288288:web:72d0d6857509d98b463dc5',
    messagingSenderId: '606858288288',
    projectId: 'realestateabd-8e69c',
    authDomain: 'realestateabd-8e69c.firebaseapp.com',
    databaseURL: 'https://realestateabd-8e69c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'realestateabd-8e69c.appspot.com',
    measurementId: 'G-S7DXVDP2LH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGACtV5MEFG-kIAXaXHzqCQOEA7tYtRbE',
    appId: '1:606858288288:android:b0a647457d892a3f463dc5',
    messagingSenderId: '606858288288',
    projectId: 'realestateabd-8e69c',
    databaseURL: 'https://realestateabd-8e69c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'realestateabd-8e69c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4LlV_XH1Dw6H3nT0ywQgAMYSrXATKuco',
    appId: '1:606858288288:ios:d63ab12299bcd91e463dc5',
    messagingSenderId: '606858288288',
    projectId: 'realestateabd-8e69c',
    databaseURL: 'https://realestateabd-8e69c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'realestateabd-8e69c.appspot.com',
    iosBundleId: 'com.example.adminPanelNayzak',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC4LlV_XH1Dw6H3nT0ywQgAMYSrXATKuco',
    appId: '1:606858288288:ios:d63ab12299bcd91e463dc5',
    messagingSenderId: '606858288288',
    projectId: 'realestateabd-8e69c',
    databaseURL: 'https://realestateabd-8e69c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'realestateabd-8e69c.appspot.com',
    iosBundleId: 'com.example.adminPanelNayzak',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBFoXgqd0CbmPV95SZqlMw3Uar_pD_zAQM',
    appId: '1:606858288288:web:4edbd681e3672009463dc5',
    messagingSenderId: '606858288288',
    projectId: 'realestateabd-8e69c',
    authDomain: 'realestateabd-8e69c.firebaseapp.com',
    databaseURL: 'https://realestateabd-8e69c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'realestateabd-8e69c.appspot.com',
    measurementId: 'G-6FWHLWHHV0',
  );
}

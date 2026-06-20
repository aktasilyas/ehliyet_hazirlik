// Placeholder — `flutterfire configure` ile güncellenmeli.
// ignore_for_file: lines_longer_than_80_chars

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
        throw UnsupportedError('Linux desteklenmiyor.');
      default:
        throw UnsupportedError('Desteklenmeyen platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'WEB_API_KEY',
    appId: '1:000000000000:web:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'ehliyet-hazirlik',
    authDomain: 'ehliyet-hazirlik.firebaseapp.com',
    storageBucket: 'ehliyet-hazirlik.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'ANDROID_API_KEY',
    appId: '1:000000000000:android:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'ehliyet-hazirlik',
    storageBucket: 'ehliyet-hazirlik.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'IOS_API_KEY',
    appId: '1:000000000000:ios:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'ehliyet-hazirlik',
    storageBucket: 'ehliyet-hazirlik.appspot.com',
    iosBundleId: 'com.senin_adin.ehliyetHazirlik',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'WINDOWS_API_KEY',
    appId: '1:000000000000:web:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'ehliyet-hazirlik',
    authDomain: 'ehliyet-hazirlik.firebaseapp.com',
    storageBucket: 'ehliyet-hazirlik.appspot.com',
  );
}

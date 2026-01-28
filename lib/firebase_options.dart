import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ആൻഡ്രോയിഡിനും വെബ്ബിന്റെ അതേ കീ ഉപയോഗിക്കാം (തുടക്കത്തിൽ)
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcxrvgGTcc-w2LgY1Hc1Jy6EPs7fJGFJs',
    appId: '1:178081719111:web:44e95480cff6df2a5a2262',
    messagingSenderId: '178081719111',
    projectId: 'fee-apk-1',
    authDomain: 'fee-apk-1.firebaseapp.com',
    storageBucket: 'fee-apk-1.firebasestorage.app',
    measurementId: 'G-EFWCZCJRSL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcxrvgGTcc-w2LgY1Hc1Jy6EPs7fJGFJs',
    appId: '1:178081719111:web:44e95480cff6df2a5a2262', 
    messagingSenderId: '178081719111',
    projectId: 'fee-apk-1',
    storageBucket: 'fee-apk-1.firebasestorage.app',
  );
}

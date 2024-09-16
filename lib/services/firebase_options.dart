import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FirebaseSetup {
  static Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAqesyD6eMKtA38eYi60BoxbFLGDWehSHU",
          appId: "1:916601440407:android:078e2f118dd07beffec1d2",
          messagingSenderId: "916601440407",
          projectId: "movieapp-83f81",
          databaseURL: "https://movieapp-83f81-default-rtdb.asia-southeast1.firebasedatabase.app",
          storageBucket: "movieapp-83f81.appspot.com",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }
}

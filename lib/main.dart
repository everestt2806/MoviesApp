import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/models/movie_provider.dart';
import 'package:movies_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Kiểm tra xem Firebase đã được khởi tạo chưa
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyDCQSocHlcHwznstM5mMHJQbO84YF5y7x4",
          appId: "1:916601440407:android:078e2f118dd07beffec1d2",
          messagingSenderId: "916601440407",
          projectId: "movieapp-83f81",
          databaseURL: "https://movieapp-83f81-default-rtdb.firebaseio.com",
        ),
      );
    } else {
      Firebase.app();
    }
  } catch (e) {
    print('Lỗi khởi tạo Firebase: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    ),
  );
}




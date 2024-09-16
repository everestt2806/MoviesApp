import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/models/movie_provider.dart';
import 'package:movies_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import'package:movies_app/screens/auth/register_screen.dart';
import'package:movies_app/services/firebase_options.dart';
import 'package:movies_app/test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup.initializeFirebase();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),  // Thêm MovieProvider ở đây
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    ),
  );
}





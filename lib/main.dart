// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pest_detection/auth/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve saved user data
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(GetMaterialApp(
      home: MyApp(
    email: email,
    password: password,
  )));
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? password;
  const MyApp({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.light,
        home: email != null && password != null
            ? const HomeScreen()
            : const LoginScreen());
  }
}

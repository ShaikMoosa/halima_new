import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Ensure this is the correct path to your login screen
import 'home_screen.dart'; // Ensure this is the correct path to your home screen

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Run your app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define the initial route
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(), // Login Screen Route
        '/home': (context) => const HomeScreen(), // Home Screen Route
      },
      home: const LoginScreen(), // Set the initial screen to the login screen
    );
  }
}

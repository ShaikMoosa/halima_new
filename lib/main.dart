import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'week_provider.dart';
import 'user_input_screen.dart';
import 'home_screen.dart';
import 'view_progress_screen.dart';
import 'login.dart'; // Create a separate screen for login

// Ensure Firebase is initialized before the app runs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeekProvider()..loadWeeksData()),
      ],
      child: const MyApp(),
    ),
  );
}

// The main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pregnancy Tracker',
      theme: ThemeData(
        primaryColor: Colors.pink.shade300,
        scaffoldBackgroundColor: Colors.pink.shade50,
        fontFamily: 'Arial',
      ),
      home: AuthWrapper(), // Use a wrapper to handle authentication state
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/viewProgress': (context) => const ViewProgressScreen(),
      },
    );
  }
}

// Wrapper to check FirebaseAuth state
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If Firebase is still initializing, show a loading screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // If user is logged in, navigate to UserInputScreen or HomeScreen
        if (snapshot.hasData) {
          return const UserInputScreen(); // Replace with the screen you want after login
        }
        // If user is not logged in, navigate to the LoginScreen
        return const LoginScreen();
      },
    );
  }
}

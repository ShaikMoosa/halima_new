import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/button.dart';
import 'package:myapp/google_auth.dart';
import 'login.dart';
import 'settings.dart'; // Import the settings page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Congratulations\nYou have successfully Logged In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            // Logout button
            MyButtons(
              onTap: () async {
                // Perform the Google sign-out
                await FirebaseServices().googleSignOut();

                // Perform Firebase sign-out (for email/password users)
                await FirebaseAuth.instance.signOut();

                // Check if the widget is still mounted before navigating
                if (!mounted) return;

                // Navigate to the login screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              text: "Log Out",
            ),
          ],
        ),
      ),
    );
  }
}

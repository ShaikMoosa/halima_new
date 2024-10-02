import 'package:flutter/material.dart';
import 'package:myapp/authentication.dart';
import 'package:myapp/button.dart';
import 'package:myapp/forgot_password.dart';
import 'package:myapp/google_auth.dart';
import 'package:myapp/snackbar.dart';
import 'package:myapp/text_feild.dart';
import 'home_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // email and password auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    // Sign up user using our auth method
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    // Set loading to false after async call
    setState(() {
      isLoading = false;
    });

    // Ensure widget is still mounted before using BuildContext
    if (!mounted) return;

    if (res == "success") {
      // Navigate to HomeScreen if login was successful
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // Show error message if login failed
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Added to handle overflow
          child: SizedBox(
            height: height, // Maintain screen height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 3.6,
                  child: Image.asset('images/halima.png'),
                ),
                TextFieldInput(
                  icon: Icons.person,
                  textEditingController: emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.text,
                ),
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const ForgotPassword(),
                MyButtons(onTap: loginUser, text: "Log In"),
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.black26),
                    ),
                    const Text("  or  "),
                    Expanded(
                      child: Container(height: 1, color: Colors.black26),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () async {
                      await FirebaseServices().signInWithGoogle();
                      // Ensure the widget is still mounted before using context
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Image.asset('images/google.png',
                            height: 35,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 100),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

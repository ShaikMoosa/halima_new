import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';  // Import your login screen here
import 'button.dart'; // Import the MyButtons class

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _babyNicknameController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'moosa'; // Example data
    _babyNicknameController.text = 'Emman'; // Example data
  }

  @override
  void dispose() {
    _nameController.dispose();
    _babyNicknameController.dispose();
    super.dispose();
  }

  // Function to log the user out
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), 
        ),
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  // Function to delete the user's account permanently
  Future<void> _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      // Check if the user is authenticated
      if (user != null) {
        await user.delete(); // Deletes the account permanently

        // Navigate to the login screen after account deletion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        print("No user is currently signed in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print("The user needs to re-authenticate before deleting the account.");
        // Here, you could re-authenticate the user if needed.
      } else {
        print("Error deleting account: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          isEditing
              ? IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      // Save changes logic here
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _babyNicknameController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Baby nickname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => PrivacyPolicyDialog(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Privacy policy'),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            MyButtons(
              onTap: _logout,
              text: 'Log out',
            ),
            const SizedBox(height: 1.0),
            // Delete account permanently button with black background
            MyButtons(
              onTap: () async {
                // Confirm before deleting the account
                bool confirm = await _showConfirmationDialog(context);
                if (confirm) {
                  _deleteAccount();
                }
              },
              text: 'Delete account permanently',
              color: Colors.black,  // Black button for account deletion
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a confirmation dialog before account deletion
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false; // Return false if the dialog is dismissed without a response
  }
}

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Effective Date: [06/11/2024]',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                '''This Privacy Policy outlines how we collect, use, disclose, and safeguard your personal information when you use our pregnancy tracking app ("the App"). By using the App, you consent to the practices described in this policy.

1. **Information We Collect**
We may collect the following types of information:
   - Personal Information: Your name, baby’s nickname, email address, and other details you voluntarily provide.
   - Usage Data: Information about how you use the app, including interactions with various features, IP address, and device information.

2. **How We Use Your Information**
We may use your information to:
   - Provide, maintain, and improve the app.
   - Personalize the user experience by storing your preferences.
   - Send you important updates, such as notifications related to the app’s functionality.
   - Ensure the security of the app.

3. **Information Sharing**
We do not sell, trade, or rent your personal information to others. We may share data with service providers who assist us in app operations, but only for the purposes described in this policy.

4. **Data Retention**
Your personal data will be retained for as long as necessary to provide the services of the app. You can request deletion of your data at any time.

5. **Your Rights**
You have the right to:
   - Access the personal data we hold about you.
   - Correct any inaccuracies in your data.
   - Request deletion of your data.

6. **Security**
We take reasonable precautions to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure.

7. **Changes to This Policy**
We may update this Privacy Policy from time to time. Any changes will be posted in the app and will become effective when published.

If you have any questions or concerns about this Privacy Policy, please contact us at [Insert Contact Information].''',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'Thank you for using our app and trusting us with your information.',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

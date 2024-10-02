import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
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
    // Initialize the controllers with existing data (this could be fetched from your backend)
    _nameController.text = 'moosa'; // Example data
    _babyNicknameController.text = 'Emman'; // Example data
  }

  @override
  void dispose() {
    _nameController.dispose();
    _babyNicknameController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to login screen or any other appropriate action
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print("Error logging out: $e");
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, // Updated for logout button color
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 16.0),
              ),
              child: const Text('Log out'),
            ),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () {
                // Handle account deletion logic
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 16.0),
              ),
              child: const Text(
                'Delete account permanently',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyDialog extends StatelessWidget {
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
                'Effective Date: [Insert Date]',
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

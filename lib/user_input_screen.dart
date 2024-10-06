import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'week_provider.dart';
import 'week_data_model.dart'; // Import the WeekData model

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  UserInputScreenState createState() => UserInputScreenState();
}

class UserInputScreenState extends State<UserInputScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  int selectedWeek = 1; // Default value for selected week

  @override
  Widget build(BuildContext context) {
    final weeksData = Provider.of<WeekProvider>(context).weeksData;

    return Scaffold(
      body: SingleChildScrollView( // Scrollable content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Space at the top for visual balance
              _buildTextField('Your name', nameController),
              const SizedBox(height: 10),
              _buildTextField('Baby nickname', nicknameController),
              const SizedBox(height: 10),
              _buildWeekDropdown(context, weeksData), // The dropdown button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to HomeScreen with the selected week and baby name as arguments
                  Provider.of<WeekProvider>(context, listen: false)
                      .selectWeekByWeek(selectedWeek);
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: {
                      'week': selectedWeek,
                      'babyName': nicknameController.text.trim().isNotEmpty
                          ? nicknameController.text.trim()
                          : null, // Pass null if no name is provided
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 150), // Space at the bottom for visual balance
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildWeekDropdown(BuildContext context, List<WeekData> weeksData) {
    return GestureDetector(
      onTap: () {
        _showWeekSelectionSheet(context, weeksData); // Show modal bottom sheet when tapped
      },
      child: AbsorbPointer(
        child: DropdownButtonFormField<int>(
          value: selectedWeek,
          items: List.generate(weeksData.length, (index) {
            int startWeek = int.parse(weeksData[index].weekRange.split('-').first);
            return DropdownMenuItem<int>(
              value: startWeek,
              child: Text('Week $startWeek'),
            );
          }),
          onChanged: (int? newValue) {
            setState(() {
              selectedWeek = newValue!;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Select Week Pregnant',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  void _showWeekSelectionSheet(BuildContext context, List<WeekData> weeksData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: weeksData.length,
            itemBuilder: (context, index) {
              final weekRange = weeksData[index].weekRange.split('-');
              int startWeek = int.parse(weekRange.first);
              return ListTile(
                title: Text('Week $startWeek'),
                onTap: () {
                  setState(() {
                    selectedWeek = startWeek; // Removed misplaced semicolon
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              );
            },
          ),
        );
      },
    );
  }
}
